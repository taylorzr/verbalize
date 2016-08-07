require 'spec_helper'

describe Verbal::BuildAttributes do
  describe '#build' do
    it 'doesn’t create any attributes when there are no keywords' do
      attributes_builder = described_class.new([])

      result = attributes_builder.build

      expect(result).to eql('')
    end

    it 'creates attributes for each keyword' do
      attributes_builder = described_class.new([:some_keyword_1, :some_keyword_2])

      result = attributes_builder.build

      expect(result).to eql('attr_reader :some_keyword_1, :some_keyword_2')
    end
  end
end
