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
    # TODO:
    # This this default to defining the method call
    # And maybe not allow other methods?
    # Or add a method verbalize_as to define a method named something else
    def verbalize(*arguments, **keyword_arguments)
      method_name, *arguments = arguments
      class_eval BuildAction.new(arguments, keyword_arguments, method_name).build
      class_eval BuildInitialize.new(arguments, keyword_arguments).build
      class_eval BuildAttributes.new(arguments, keyword_arguments).build
    end
  end
end
