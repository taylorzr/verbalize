require_relative 'build_method_base'

module Verbal
  class BuildArgumentValidator < BuildMethodBase
    private

    def declaration
      'def self._verbalize_validate_arguments(instance)'
    end

    def body
      return if keywords.empty?
      (check_values + raise_error_if_necessary).join("\n")
    end

    def check_values
      [
        "keywords = [#{keywords.map(&:inspect).join(', ')}]",
        'keywords_without_values = keywords.select do |keyword|',
        '  instance.send(keyword).nil?',
        'end'
      ]
    end

    def raise_error_if_necessary
      [
        'if keywords_without_values.any?',
        "  error_message = 'missing keyword'",
        "  error_message += 's' if keywords_without_values.count > 1",
        %q{  error_message += ": #{keywords_without_values.join(', ')}"},
        '  raise ArgumentError.new(error_message)',
        'end'
      ]
    end
  end
end
