require_relative 'error'
require_relative 'build_initialize_method'
require_relative 'build_safe_action_method'
require_relative 'build_dangerous_action_method'
require_relative 'build_attribute_readers'
require_relative 'success'
require_relative 'failure'

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
      def input( # rubocop:disable Metrics/MethodLength
        *required_keywords,
        optional: [],
        **other_keyword_arguments
      )
        unless other_keyword_arguments.empty?
          raise(
            ArgumentError,
            "Unsupported keyword arguments received: #{other_keyword_arguments.inspect}"
          )
        end

        optional_keywords = Array(optional)

        class_eval BuildSafeActionMethod.call(
          required_keywords: required_keywords,
          optional_keywords: optional_keywords
        )

        class_eval BuildDangerousActionMethod.call(
          required_keywords: required_keywords,
          optional_keywords: optional_keywords
        )

        class_eval BuildInitializeMethod.call(
          required_keywords: required_keywords,
          optional_keywords: optional_keywords
        )

        class_eval BuildAttributeReaders.call(
          attributes: required_keywords + optional_keywords
        )
      end

      def call
        __verbalized_send(:call)
      end

      def call!
        __verbalized_send!(:call)
      end

      private

      def __verbalized_send(method_name, *args)
        error = catch(:verbalize_error) do
          value = new(*args).send(method_name)
          return Success.new(value)
        end

        Failure.new(error)
      end

      def __verbalized_send!(method_name, *args)
        new(*args).send(method_name)
      rescue UncaughtThrowError => uncaught_throw_error
        fail_value = uncaught_throw_error.value
        error = Verbalize::Error.new("Unhandled fail! called with: #{fail_value.inspect}.")
        error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
        raise error
      end
    end
  end
end
