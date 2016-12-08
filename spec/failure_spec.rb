require 'spec_helper'
require 'verbalize/failure'

describe Verbalize::Failure do
  describe '#succeeded?' do
    it 'is false' do
      result = described_class.new(nil)

      expect(result).not_to be_succeeded
    end
  end

  describe '#success?' do
    it 'is false' do
      result = described_class.new(nil)

      expect(result).not_to be_success
    end
  end

  describe '#failed?' do
    it 'is true' do
      result = described_class.new(nil)

      expect(result).to be_failed
    end
  end

  describe '#failure?' do
    it 'is true' do
      result = described_class.new(nil)

      expect(result).to be_failure
    end
  end

  describe '#outcome' do
    it 'is :error' do
      result = described_class.new(nil)

      expect(result.outcome).to be :error
    end
  end

  describe '#error' do
    it 'is the error message' do
      result = described_class.new('some_error')

      expect(result.error).to eq 'some_error'
    end
  end

  describe '#value' do
    it 'is the error message' do
      result = described_class.new('some_error')

      expect(result.value).to eq 'some_error'
    end

    it 'emits a deprecation warning' do
      expected_message = %r{.*failure_spec.rb:\d+:in .*: `Verbalize::Result#value` is deprecated; use `Verbalize::Failure#error` or `Verbalize::Success#value` instead\.  It will be removed from `Verbalize::Result` in Verbalize version 2\.0}
      result = described_class.new('some_error')
      expect {
        result.value
      }.to output(expected_message).to_stderr
    end
  end

  describe '#to_ary' do
    it 'returns an array containing the outcome and value' do
      instance = described_class.new('foo')

      expect(instance.to_ary).to eq [:error, 'foo']
    end

    it 'allows multiple assignment' do
      instance = described_class.new('foo')

      outcome, value = instance

      expect(outcome).to eq :error
      expect(value).to eq 'foo'
    end
  end
end
