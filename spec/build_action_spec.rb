require 'spec_helper'

describe Verbalize::BuildAction do
  describe '#build' do
    it 'builds a method string with no keywords' do
      action_builder = described_class.new([])

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call()
              action = new()
              _verbalize_validate_arguments(action)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with no keywords and a given method name' do
      action_builder = described_class.new([], :some_action)

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action()
              action = new()
              _verbalize_validate_arguments(action)
              value = catch(:verbalize_error) { action.some_action }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with one keyword' do
      action_builder = described_class.new([:some_lonely_keyword])

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_lonely_keyword: nil)
              action = new(some_lonely_keyword: some_lonely_keyword)
              _verbalize_validate_arguments(action)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with multiple keywords' do
      action_builder = described_class.new([:some_keyword_1, :some_keyword_2])

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_keyword_1: nil, some_keyword_2: nil)
              action = new(some_keyword_1: some_keyword_1, some_keyword_2: some_keyword_2)
              _verbalize_validate_arguments(action)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end
  end
end
