require 'verbal/version'
require 'verbal/build_initialize'
require 'verbal/build_action'
require 'verbal/build_attributes'
require 'verbal/result'

module Verbal
  def outcome
    @outcome = @fail || :success
  end

  def fail!
    @fail = :failure
  end

  def self.included(target)
    target.extend ClassMethods
  end

  private

  module ClassMethods
    def input(*arguments, verbal_method_name: :call, **keyword_arguments)
      class_eval BuildAction.new(arguments, keyword_arguments, verbal_method_name).build
      class_eval BuildInitialize.new(arguments, keyword_arguments).build
      class_eval BuildAttributes.new(arguments, keyword_arguments).build
    end

    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      input(*arguments, verbal_method_name: method_name, **keyword_arguments)
    end
  end
end
