require 'verbal/version'
require 'verbal/build_initialize'
require 'verbal/build_action'
require 'verbal/build_attributes'
require 'verbal/build_argument_validator'
require 'verbal/result'

module Verbal
  REQUIRED_ARGUMENT_VALUE = :_verbal_required_argument_value

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
      new.call
    end

    def input(*arguments, verbal_method_name: :call, **keyword_arguments)
      class_eval BuildAction.new(arguments, keyword_arguments, verbal_method_name).build
      class_eval BuildInitialize.new(arguments, keyword_arguments).build
      class_eval BuildAttributes.new(arguments, keyword_arguments).build
      class_eval BuildArgumentValidator.new(arguments).build
    end

    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      input(*arguments, verbal_method_name: method_name, **keyword_arguments)
    end

    private

    def _verbalize_clean_arguments(parameters, action_binding)
      parameters.each do |_type, variable_name|
        if action_binding.local_variable_get(variable_name) == Verbal::REQUIRED_ARGUMENT_VALUE
          action_binding.local_variable_set(variable_name, nil)
        end
      end
    end
  end
end
