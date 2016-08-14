require 'verbalize/version'
require 'verbalize/build_initialize_method'
require 'verbalize/build_action_method'
require 'verbalize/build_dangerous_action_method'
require 'verbalize/build_attribute_readers'
require 'verbalize/result'

module Verbalize
  def fail!(failure_value)
    throw(:verbalize_error, Result.new(outcome: :error, value: failure_value))
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

      class_eval BuildActionMethod.call(
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
      action = new
      result = catch(:verbalize_error) { action.send(:call) }
      if result.is_a?(Result)
        result
      else
        Result.new(outcome: :ok, value: result)
      end
    end

    def call!
      new.send(:call)
    end
  end
end
