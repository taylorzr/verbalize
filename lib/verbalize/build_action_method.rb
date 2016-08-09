require_relative 'build_method_base'

module Verbalize
  class BuildActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      [
        "action = new(#{initialize_keyword_arguments})",
        "value = catch(:verbalize_error) { action.#{method_name} }",
        'Result.new(outcome: action.outcome, value: value)'
      ].join("\n")
    end

    def initialize_keyword_arguments
      all_keywords.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
