require 'verbalize/version'
require 'verbalize/build_initialize_method'
require 'verbalize/build_safe_action_method'
require 'verbalize/build_dangerous_action_method'
require 'verbalize/build_attribute_readers'
require 'verbalize/success'
require 'verbalize/failure'

module Verbalize
  THROWN_SYMBOL = :verbalize_error
  VerbalizeError = Class.new(StandardError) do
    def initialize(failure)
      @failure = failure
      message = "Unhandled fail! called with: #{failure.inspect}."
      super(message)
    end

    attr_reader :failure
  end

  def fail!(failure_value = nil)
    # Maybe we should wrap the `failure_value` in a Failure object here instead of throwing the raw value up the stack?
    throw(THROWN_SYMBOL, failure_value)
  end

  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods
    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      input(*arguments, method_name: method_name, **keyword_arguments)
    end

    def input( # rubocop:disable Metrics/MethodLength
      *required_keywords,
      optional:    [],
      method_name: :call,
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
        optional_keywords: optional_keywords,
        method_name:       method_name
      )

      class_eval BuildDangerousActionMethod.call(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords,
        method_name:       method_name
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
    rescue VerbalizeError => e
      Failure.new(e.failure)
    end

    def __verbalized_send!(method_name, *args)
      new(*args).send(method_name)
    rescue UncaughtThrowError => uncaught_throw_error
      raise uncaught_throw_error unless uncaught_throw_error.tag == THROWN_SYMBOL
      failure = uncaught_throw_error.value
      error = VerbalizeError.new(failure)
      error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
      raise error
    end
  end
end
