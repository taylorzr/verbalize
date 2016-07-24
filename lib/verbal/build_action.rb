require_relative 'build_method_base'

module Verbal
  class BuildAction < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      [
        "action = self.new(#{initialize_keyword_arguments})",
        "value = action.#{method_name}",
        "Result.new(outcome: action.outcome, value: value)"
      ].join("\n")
    end

    def initialize_keyword_arguments
      variables.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
