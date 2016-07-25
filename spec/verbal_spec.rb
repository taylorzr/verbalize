require 'spec_helper'

describe Verbal do
  it 'has a version number' do
    expect(Verbal::VERSION).not_to be nil
  end

  describe '.verbalize' do
    let(:some_class) do
      Class.new do
        include Verbal
      end
    end

    describe 'action class method' do
      it 'is named using the first argument' do
        some_class.verbalize :some_action

        expect(some_class).to respond_to(:some_action)
      end

      it 'requires the user to implement behaviour in an instance method of the same name' do
        some_class.verbalize :some_action

        expect{ some_class.some_action }.to raise_error(NoMethodError)
      end

      it 'creates a new instance of itself, and calls the matching instance method' do
        some_class.verbalize :some_action

        some_class.class_eval do
          def some_action
            42
          end
        end

        expect(some_class.some_action).to eql [:ok, 42]
      end

      context 'with arguments' do
        before do
          some_class.class_eval do
            def some_action
              some_required_argument_1 + some_required_argument_2
            end
          end
        end

        it 'raises an ArgumentError without a value' do
          some_class.verbalize(:some_action,
                               :some_required_argument_1,
                               :some_required_argument_2)

          expect{ some_class.some_action }.to raise_error(ArgumentError)
        end

        it 'doesn’t raise an error with a value' do
          some_class.verbalize(:some_action,
                               :some_required_argument_1,
                               :some_required_argument_2)

          expect do
            some_class.some_action(some_required_argument_1: 333,
                                   some_required_argument_2: 333)
          end.not_to raise_error(ArgumentError)
        end

        it 'makes the provided values available as attributes' do
          some_class.verbalize(:some_action,
                               :some_required_argument_1,
                               :some_required_argument_2)

          expect(some_class.some_action(some_required_argument_1: 21,
                                        some_required_argument_2: 21)).to eql [:ok, 42]
        end
      end

      context 'with keyword arguments' do
        before do
          some_class.class_eval do
            def some_action
              some_keyword_1 + some_keyword_2
            end
          end
        end

        it 'provides the keyword values as defaults' do
          some_class.verbalize(:some_action,
                               some_keyword_1: 21,
                               some_keyword_2: 21)

          expect(some_class.some_action).to eql [:ok, 42]
        end

        it 'allows the defaults to be overriden' do
          some_class.verbalize(:some_action,
                               some_keyword_1: 21,
                               some_keyword_2: 21)

          expect(some_class.some_action(some_keyword_1: 333, some_keyword_2: 333))
            .to eql [:ok, 666]
        end
      end
    end
  end
end
