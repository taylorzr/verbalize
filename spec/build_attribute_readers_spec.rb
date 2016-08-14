require 'spec_helper'

describe Verbalize::BuildAttributeReaders do
  describe '.call' do
    it 'doesn’t create any attributes when there are no attributes' do
      result = described_class.call

      expect(result).to eql('')
    end

    it 'creates attributes for each attribute' do
      result = described_class.call(attributes: [:some_attribute_1, :some_attribute_2])

      expect(result).to eql('attr_reader :some_attribute_1, :some_attribute_2')
    end
  end
end
