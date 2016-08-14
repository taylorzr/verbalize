require 'spec_helper'

describe Verbalize::BuildSafeActionMethod do
  describe '.call' do
    it 'builds a method string with no keywords' do
      result = described_class.call

      expect(result).to eql(<<-METHOD)
def self.call()
  action = new()
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with no keywords and a given method name' do
      result = described_class.call(method_name: :some_action)

      expect(result).to eql(<<-METHOD)
def self.some_action()
  action = new()
  result = catch(:verbalize_error) { action.send(:some_action) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with one required keyword' do
      result = described_class.call(required_keywords: [:some_lonely_required_keyword])

      expect(result).to eql(<<-METHOD)
def self.call(some_lonely_required_keyword:)
  action = new(some_lonely_required_keyword: some_lonely_required_keyword)
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with one optional keyword' do
      result = described_class.call(optional_keywords: [:some_lonely_optional_keyword])

      expect(result).to eql(<<-METHOD)
def self.call(some_lonely_optional_keyword: nil)
  action = new(some_lonely_optional_keyword: some_lonely_optional_keyword)
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with multiple required keywords' do
      result = described_class.call(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call(some_required_keyword_1:, some_required_keyword_2:)
  action = new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2)
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with multiple optional keywords' do
      result = described_class.call(
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call(some_optional_keyword_1: nil, some_optional_keyword_2: nil)
  action = new(some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2)
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end

    it 'builds a method string with multiple required and multiple optional keywords' do
      result = described_class.call(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2],
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call(some_required_keyword_1:, some_required_keyword_2:, some_optional_keyword_1: nil, some_optional_keyword_2: nil)
  action = new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2, some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2)
  result = catch(:verbalize_error) { action.send(:call) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
end
      METHOD
    end
  end
end
