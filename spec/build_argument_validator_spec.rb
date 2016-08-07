require 'spec_helper'

describe Verbalize::BuildArgumentValidator do
  describe '#build' do
    it 'builds a method with no keywords' do
      builder = described_class.new([])

      result = builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
           def self._verbalize_validate_arguments(instance)
           end
        METHOD
      )
    end

    it 'builds a method with keywords' do
      builder = described_class.new([:some_keyword_1, :some_keyword_2])

      result = builder.build

      expect(result).to eql(
        <<-METHOD.chomp
def self._verbalize_validate_arguments(instance)
keywords = [:some_keyword_1, :some_keyword_2]
keywords_without_values = keywords.select do |keyword|
  instance.send(keyword).nil?
end
if keywords_without_values.any?
  error_message = 'missing keyword'
  error_message += 's' if keywords_without_values.count > 1
  error_message += ": \#{keywords_without_values.join(', ')}"
  raise ArgumentError.new(error_message)
end
end
        METHOD
      )
    end
  end
end
