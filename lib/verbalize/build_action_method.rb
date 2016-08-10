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
        "value = catch(:verbalize_error) { action.send(#{method_name.inspect}) }",
        'outcome = action.instance_variable_get(:@verbalize_outcome) || :ok',
        'Result.new(outcome: outcome, value: value)'
      ].join("\n")
    end

    def initialize_keyword_arguments
      all_keywords.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
