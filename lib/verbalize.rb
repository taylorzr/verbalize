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
    def call
      action = new
      value = catch(:verbalize_error) { action.call }
      Result.new(outcome: action.outcome, value: value)
    end

    def input(*required_keywords, optional: [], method_name: :call, **keyword_arguments)
      raise ArgumentError unless keyword_arguments.empty?

      optional_keywords = Array(optional)

      action_method_string = BuildAction.new(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords,
        method_name: method_name
      ).build

      initialize_method_string = BuildInitialize.new(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords
      ).build

      attribute_reader_string = BuildAttributes.new(
        attributes: required_keywords + optional_keywords
      ).build

      class_eval action_method_string
      class_eval initialize_method_string
      class_eval attribute_reader_string
    end

    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      input(*arguments, method_name: method_name, **keyword_arguments)
    end
  end
end
