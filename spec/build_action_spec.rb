require 'spec_helper'

describe Verbal::BuildAction do
  describe 'build' do
    subject(:action_builder) do
      described_class.new(arguments, :some_action)
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
              _verbalize_validate_arguments(action)
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
            def self.some_action(some_argument: nil)
              action = new(some_argument: some_argument)
              _verbalize_validate_arguments(action)
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
            def self.some_action(some_argument_1: nil, some_argument_2: nil)
              action = new(some_argument_1: some_argument_1, some_argument_2: some_argument_2)
              _verbalize_validate_arguments(action)
              value = action.some_action
              Result.new(outcome: action.outcome, value: value)
            end
          METHOD
        )
      end
    end
  end
end
