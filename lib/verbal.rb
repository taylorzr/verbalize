require 'verbal/version'
require 'verbal/build_initialize'
require 'verbal/build_action'
require 'verbal/build_attributes'

module Verbal
  def verbalize(*arguments, **keyword_arguments)
    method_name, *arguments = arguments
    class_eval BuildAction.new(arguments, keyword_arguments, method_name).build
    class_eval BuildInitialize.new(arguments, keyword_arguments).build
    class_eval BuildAttributes.new(arguments, keyword_arguments).build
  end
end
