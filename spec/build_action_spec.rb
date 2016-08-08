require 'spec_helper'

describe Verbalize::BuildAction do
  describe '#build' do
    it 'builds a method string with no keywords' do
      action_builder = described_class.new

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call()
              action = new()
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with no keywords and a given method name' do
      action_builder = described_class.new(method_name: :some_action)

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action()
              action = new()
              value = catch(:verbalize_error) { action.some_action }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with one required keyword' do
      action_builder = described_class.new(required_keywords: [:some_lonely_required_keyword])

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_lonely_required_keyword:)
              action = new(some_lonely_required_keyword: some_lonely_required_keyword)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with one optional keyword' do
      action_builder = described_class.new(optional_keywords: [:some_lonely_optional_keyword])

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_lonely_optional_keyword: nil)
              action = new(some_lonely_optional_keyword: some_lonely_optional_keyword)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with multiple required keywords' do
      action_builder = described_class.new(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2]
      )

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_required_keyword_1:, some_required_keyword_2:)
              action = new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with multiple optional keywords' do
      action_builder = described_class.new(
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_optional_keyword_1: nil, some_optional_keyword_2: nil)
              action = new(some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end

    it 'builds a method string with multiple required and multiple optional keywords' do
      action_builder = described_class.new(
        required_keywords: [:some_required_keyword_1, :some_required_keyword_2],
        optional_keywords: [:some_optional_keyword_1, :some_optional_keyword_2]
      )

      result = action_builder.build

      expect(result).to eql(
        <<-METHOD.gsub(/^\s*/, '').chomp
            def self.call(some_required_keyword_1:, some_required_keyword_2:, some_optional_keyword_1: nil, some_optional_keyword_2: nil)
              action = new(some_required_keyword_1: some_required_keyword_1, some_required_keyword_2: some_required_keyword_2, some_optional_keyword_1: some_optional_keyword_1, some_optional_keyword_2: some_optional_keyword_2)
              value = catch(:verbalize_error) { action.call }
              Result.new(outcome: action.outcome, value: value)
            end
        METHOD
      )
    end
  end
end
