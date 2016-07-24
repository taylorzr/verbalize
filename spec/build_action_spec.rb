require 'spec_helper'

describe Verbal::BuildAction do
  describe 'build' do
    subject(:action_builder) do
      described_class.new(arguments, keyword_arguments, :some_action)
    end
    let(:arguments)          { [] }
    let(:keyword_arguments)  { {} }

    context 'with only a method name' do
      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action()
              action = new()
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name and 1 argument' do
      let(:arguments) { [:some_argument] }

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_argument:)
              action = new(some_argument: some_argument)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name and multiple arguments' do
      let(:arguments) { [:some_argument_1, :some_argument_2] }

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_argument_1:, some_argument_2:)
              action = new(some_argument_1: some_argument_1, some_argument_2: some_argument_2)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name and 1 keyword argument' do
      let(:keyword_arguments) { { some_keyword: :some_default } }

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_keyword: :some_default)
              action = new(some_keyword: some_keyword)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name and multiple keyword arguments' do
      let(:keyword_arguments) do
        { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
      end

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_keyword_1: :some_default_1, some_keyword_2: :some_default_2)
              action = new(some_keyword_1: some_keyword_1, some_keyword_2: some_keyword_2)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name, 1 argument, and 1 keyword argument' do
      let(:arguments)         { [:some_argument] }
      let(:keyword_arguments) { { some_keyword: :some_default } }

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_argument:, some_keyword: :some_default)
              action = new(some_argument: some_argument, some_keyword: some_keyword)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end

    context 'with a method name, multiple arguments, and multiple keyword arguments' do
      let(:arguments) { [:some_argument_1, :some_argument_2] }

      let(:keyword_arguments) do
        { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
      end

      it do
        method_string = action_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def self.some_action(some_argument_1:, some_argument_2:, some_keyword_1: :some_default_1, some_keyword_2: :some_default_2)
              action = new(some_argument_1: some_argument_1, some_argument_2: some_argument_2, some_keyword_1: some_keyword_1, some_keyword_2: some_keyword_2)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end
  end
end
