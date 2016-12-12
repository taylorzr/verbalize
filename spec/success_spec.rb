require 'spec_helper'
require 'verbalize/success'

describe Verbalize::Success do
  describe '#succeeded?' do
    it 'is true' do
      result = described_class.new(nil)

      expect(result).to be_succeeded
    end
  end

  describe '#success?' do
    it 'is true' do
      result = described_class.new(nil)

      expect(result).to be_success
    end
  end

  describe '#failed?' do
    it 'is false' do
      result = described_class.new(nil)

      expect(result).not_to be_failed
    end
  end

  describe '#failure?' do
    it 'is false' do
      result = described_class.new(nil)

      expect(result).not_to be_failure
    end
  end

  describe '#outcome' do
    it 'is :ok' do
      result = described_class.new(nil)

      expect(result.outcome).to be :ok
    end
  end

  describe '#value' do
    it 'is simply the value' do
      result = described_class.new('some_value')

      expect(result.value).to eq 'some_value'
    end
  end

  describe '#to_ary' do
    it 'returns an array containing the outcome and value' do
      instance = described_class.new('foo')

      expect(instance.to_ary).to eq [:ok, 'foo']
    end

    it 'allows multiple assignment' do
      instance = described_class.new('foo')

      outcome, value = instance

      expect(outcome).to eq :ok
      expect(value).to eq 'foo'
    end
  end
end
