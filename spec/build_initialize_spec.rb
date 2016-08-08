require 'spec_helper'

describe Verbalize::BuildInitialize do
  describe '#build' do
    it 'builds a method string with no keywords' do
      initialize_builder = described_class.new

      result = initialize_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
          def initialize()
          end
        METHOD
      )
    end

    it 'builds a method string with one keyword' do
      initialize_builder = described_class.new(required_keywords: [:some_keyword])

      result = initialize_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_keyword:)
              @some_keyword = some_keyword
            end
        METHOD
      )
    end

    it 'builds a method string with multiple keywords' do
      initialize_builder = described_class.new(required_keywords: [:some_argument_1, :some_argument_2])

      result = initialize_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_argument_1:, some_argument_2:)
            @some_argument_1 = some_argument_1
            @some_argument_2 = some_argument_2
            end
        METHOD
      )
    end
  end
end
