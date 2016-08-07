require 'verbalize/version'
require 'verbalize/build_initialize'
require 'verbalize/build_action'
require 'verbalize/build_attributes'
require 'verbalize/build_argument_validator'
require 'verbalize/result'

module Verbalize
  def outcome
    @outcome = @fail || :ok
  end

  def fail!
    @fail = :error
  end

  def self.included(target)
    target.extend ClassMethods
  end

  module ClassMethods
    def call
      action = new
      value = action.call
      Result.new(outcome: action.outcome, value: value)
    end

    def input(*arguments, verbalize_method_name: :call, **keyword_arguments)
      # TODO
      # Allow configuration to disable Result object return
      # Make fail stop action execution
      raise ArgumentError unless keyword_arguments.empty?
      class_eval BuildAction.new(arguments, verbalize_method_name).build
      class_eval BuildInitialize.new(arguments).build
      class_eval BuildAttributes.new(arguments).build
      class_eval BuildArgumentValidator.new(arguments).build
    end

    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      input(*arguments, verbalize_method_name: method_name, **keyword_arguments)
    end
  end
end
