require 'verbalize/version'
require 'verbalize/build_initialize'
require 'verbalize/build_action'
require 'verbalize/build_attributes'
require 'verbalize/result'

module Verbalize
  def outcome
    @outcome = @fail || :ok
  end

  def fail!(failure_value)
    @fail = :error
    throw :verbalize_error, failure_value
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
        raise ArgumentError,
              "Unsupported keyword arguments received: #{other_keyword_arguments.inspect}"
      end

      optional_keywords = Array(optional)

      class_eval BuildAction.call(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords,
        method_name:       method_name
      )

      class_eval BuildInitialize.call(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords
      )

      class_eval BuildAttributes.call(attributes: required_keywords + optional_keywords)
    end

    def call
      action = new
      value = catch(:verbalize_error) { action.call }
      Result.new(outcome: action.outcome, value: value)
    end
  end
end
