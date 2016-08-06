require_relative 'build_method_base'

module Verbal
  class BuildAction < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      [
        # "#{arguments_array}.each do |argument|",
        # "  if binding.local_variable_get(argument) == #{Verbal::REQUIRED_ARGUMENT_VALUE.inspect}",
        # "    binding.local_variable_set(argument, nil)",
        # "  end",
        # "end",
        "_verbalize_clean_arguments(method(__method__).parameters, binding)",
        "action = new(#{initialize_keyword_arguments})",
        '_verbalize_validate_arguments(action)',
        "value = action.#{method_name}",
        'Result.new(outcome: action.outcome, value: value)'
      ].join("\n")
    end

    def initialize_keyword_arguments
      variables.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end

    def arguments_array
      "[#{arguments.map(&:inspect).join(', ')}]"
    end
  end
end
