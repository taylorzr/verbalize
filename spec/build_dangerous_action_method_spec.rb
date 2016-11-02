require 'spec_helper'

describe Verbalize::BuildDangerousActionMethod do
  describe '.call' do
    it 'builds a method string with no keywords' do
      result = described_class.call

      expect(result).to eql(<<-METHOD)
def self.call!()
  new().send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with no keywords and a given method name' do
      result = described_class.call(method_name: :some_action)

      expect(result).to eql(<<-METHOD)
def self.some_action!()
  new().send(:some_action)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with one required keyword' do
      result = described_class.call(required_keywords: [:some_required_keyword])

      expect(result).to eql(<<-METHOD)
def self.call!(some_required_keyword:)
  new(some_required_keyword: some_required_keyword).send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with one optional keyword' do
      result = described_class.call(optional_keywords: [:some_optional_keyword])

      expect(result).to eql(<<-METHOD)
def self.call!(some_optional_keyword: nil)
  new(some_optional_keyword: some_optional_keyword).send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with multiple required keywords' do
      result = described_class.call(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call!(some_required_keyword_1:, some_required_keyword_2:)
  new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2).send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with multiple optional keywords' do
      result = described_class.call(
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call!(some_optional_keyword_1: nil, some_optional_keyword_2: nil)
  new(some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2).send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end

    it 'builds a method string with multiple required and multiple optional keywords' do
      result = described_class.call(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2],
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      expect(result).to eql(<<-METHOD)
def self.call!(some_required_keyword_1:, some_required_keyword_2:, some_optional_keyword_1: nil, some_optional_keyword_2: nil)
  new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2, some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2).send(:call)
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
end
      METHOD
    end
  end
end
