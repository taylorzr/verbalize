require 'spec_helper'

describe Verbalize do
  describe '.verbalize' do
    context 'with arguments' do
      it 'it allows arguments to be defined and \
      delegates the class method to the instance method' do
        some_class = Class.new do
          include Verbalize

          input :a, :b

          def call
            a + b
          end
        end

        _outcome, value = some_class.call(a: 40, b: 2)

        expect(value).to eql(42)
      end

      it 'raises an error when you don’t specify any required argument' do
        some_class = Class.new do
          include Verbalize

          input :a, :b

          def call
          end
        end

        expect { some_class.call(a: 42) }.to raise_error(ArgumentError)
      end

      it 'allows you to specify an optional argument' do
        some_class = Class.new do
          include Verbalize

          input :a, optional: :b

          def call
            a + b
          end

          def b
            @b ||= 2
          end
        end

        _outcome, value = some_class.call(a: 40)

        expect(value).to eql(42)
      end

      it 'allows you to fail an action and not execute remaining lines' do
        some_class = Class.new do
          include Verbalize

          input :a, :b

          def call
            fail! 'Are you crazy?!? You can’t divide by zero!'
            a / b
          end
        end

        outcome, value = some_class.call(a: 1, b: 0)

        expect(outcome).to eql(:error)
        expect(value).to eql('Are you crazy?!? You can’t divide by zero!')
      end
    end

    context 'without_arguments' do
      it 'still does something' do
        some_class = Class.new do
          include Verbalize

          def call
            :some_behavior
          end
        end

        _outcome, value = some_class.call

        expect(value).to eql(:some_behavior)
      end

      it 'allows you to fail an action and not execute remaining lines' do
        some_class = Class.new do
          include Verbalize

          def call
            fail! 'Are you crazy?!? You can’t divide by zero!'
            1 / 0
          end
        end

        outcome, value = some_class.call

        expect(outcome).to eql(:error)
        expect(value).to eql('Are you crazy?!? You can’t divide by zero!')
      end
    end
  end
end
