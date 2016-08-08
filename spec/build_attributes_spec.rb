require 'spec_helper'

describe Verbalize::BuildAttributes do
  describe '#build' do
    it 'doesn’t create any attributes when there are no attributes' do
      attributes_builder = described_class.new

      result = attributes_builder.build

      expect(result).to eql('')
    end

    it 'creates attributes for each attribute' do
      attributes_builder = described_class.new(attributes: [:some_attribute_1, :some_attribute_2])

      result = attributes_builder.build

      expect(result).to eql('attr_reader :some_attribute_1, :some_attribute_2')
    end
  end
end
