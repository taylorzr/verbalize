require_relative 'build_method_base'

module Verbal
  class BuildArgumentValidator < BuildMethodBase
    private

    def declaration
      "def self._verbalize_validate_arguments(instance)"
    end

    def body
      [
        "arguments = #{arguments_array}",
        "arguments_without_values = arguments.select do |argument|",
        "  instance.send(argument).nil?",
        'end',
        'if arguments_without_values.any?',
        %q{  error_message = 'missing keyword'},
        %q{  error_message += 's' if arguments_without_values.count > 1},
        %q{  error_message += ": #{arguments_without_values.join(', ')}"},
        '  raise ArgumentError.new(error_message)',
        'end'
      ].join("\n")
    end

    def arguments_array
      "[#{arguments.map(&:inspect).join(', ')}]"
    end
  end
end

