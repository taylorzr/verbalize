require 'spec_helper'

describe Verbal::Result do
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

  describe '#outcome' do
    it 'is simply the outcome' do
      result = described_class.new(outcome: :some_outcome, value: nil)

      expect(result.outcome).to eql(:some_outcome)
    end
  end

  describe '#value' do
    it 'is simply the value' do
      result = described_class.new(outcome: nil, value: :some_value)

      expect(result.value).to eql(:some_value)
    end
  end
end
