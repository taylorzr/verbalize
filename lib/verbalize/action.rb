require_relative 'build'
require_relative 'error'
require_relative 'failure'
require_relative 'success'

module Verbalize
  module Action
    THROWN_SYMBOL = :verbalize_error

    def fail!(failure_value = nil)
      throw(THROWN_SYMBOL, failure_value)
    end

    def self.included(target)
      target.extend ClassMethods
    end

    module ClassMethods
      def required_inputs
        @required_inputs || []
      end

      def optional_inputs
        @optional_inputs || []
      end

      def default_inputs
        (@defaults || {}).keys
      end

      def inputs
        required_inputs + optional_inputs + default_inputs
      end

      def defaults
        @defaults
      end

      # Because call/call! are defined when Action.input is called, they would
      # not be defined when there is no input. So we pre-define them here, and
      # if there is any input, they are overwritten
      def call
        __proxied_call
      end

      def call!
        __proxied_call!
      end
      alias_method :!, :call!

      private

      def input(*required_keywords, optional: [])
        @required_inputs = required_keywords
        optional = Array(optional)
        @optional_inputs = optional.reject { |kw| kw.is_a?(Hash) }
        @defaults = optional.select { |kw| kw.is_a?(Hash) }.reduce(&:merge)
        @defaults = (@defaults || {}).
          map { |k, v| [k, v.respond_to?(:call) ? v : lambda { v }] }.
          to_h

        class_eval Build.call(required_keywords, optional)
      end

      def perform(*args)
        new(*args).send(:call)
      end

      # We used __proxied_call/__proxied_call! for 2 reasons:
      #   1. The declaration of call/call! needs to be explicit so that tools
      #      like rspec-mocks can verify the actions keywords actually
      #      exist when stubbing
      #   2. Because #1, meta-programming a simple interface to these proxied
      #      methods is much simpler than meta-programming the full methods
      def __proxied_call(*args)
        error = catch(:verbalize_error) do
          value = perform(*args)
          return Success.new(value)
        end

        Failure.new(error)
      end

      def __proxied_call!(*args)
        perform(*args)
      rescue UncaughtThrowError => uncaught_throw_error
        fail_value = uncaught_throw_error.value
        error = Verbalize::Error.new("Unhandled fail! called with: #{fail_value.inspect}.")
        error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
        raise error
      end
    end
  end
end
