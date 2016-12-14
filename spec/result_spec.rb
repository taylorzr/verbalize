require 'spec_helper'

describe Verbalize::Result do
  describe '#succeeded?' do
    it 'is true when the outcome is not :error' do
      result = described_class.new(outcome: :not_error, value: nil)

      expect(result).to be_succeeded
    end

    it 'is false when the outcome is :error' do
      result = described_class.new(outcome: :error, value: nil)

      expect(result).not_to be_succeeded
    end
  end

  describe '#success?' do
    it 'is true when the outcome is not :error' do
      result = described_class.new(outcome: :not_error, value: nil)

      expect(result).to be_success
    end

    it 'is false when the outcome is :error' do
      result = described_class.new(outcome: :error, value: nil)

      expect(result).not_to be_success
    end
  end

  describe '#failed?' do
    it 'is false when the outcome is not :error' do
      result = described_class.new(outcome: :not_error, value: nil)

      expect(result).not_to be_failed
    end

    it 'is true when the outcome is :error' do
      result = described_class.new(outcome: :error, value: nil)

      expect(result).to be_failed
    end
  end

  describe '#failure?' do
    it 'is false when the outcome is not :error' do
      result = described_class.new(outcome: :not_error, value: nil)

      expect(result).not_to be_failure
    end

    it 'is true when the outcome is :error' do
      result = described_class.new(outcome: :error, value: nil)

      expect(result).to be_failure
    end
  end

  describe '#outcome' do
    it 'is simply the outcome' do
      result = described_class.new(outcome: :some_outcome, value: nil)

      expect(result.outcome).to eql(:some_outcome)
    end
  end

  describe '#value' do
    it 'raises a NotImplementedError when not overridden' do
      result = described_class.new(outcome: nil, value: :some_value)
      expect do
        result.value
      end.to raise_error(NotImplementedError, 'Subclasses must override Verbalize::Result#value')
    end
  end

  describe '#to_ary' do
    it 'returns an array containing the outcome and value' do
      instance = described_class.new(outcome: :not_error, value: 'foo')

      expect(instance.to_ary).to eq [:not_error, 'foo']
    end

    it 'allows multiple assignment' do
      instance = described_class.new(outcome: :not_error, value: 'foo')

      outcome, value = instance

      expect(outcome).to eq :not_error
      expect(value).to eq 'foo'
    end
  end
end
