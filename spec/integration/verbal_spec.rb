require 'spec_helper'

describe Verbal do
  describe '.verbalize' do
    context 'with arguments' do
      it 'it allows arguments to be defined and \
      delegates the class method to the instance method' do
        some_class = Class.new do
          include Verbal

          input :a, :b

          def call
            a + b
          end
        end

        _outcome, value = some_class.call(a: 40, b: 2)

        expect(value).to eql(42)
      end

      it 'raises an error when you don’t specify any argument' do
        some_class = Class.new do
          include Verbal

          input :a, :b

          def call
          end
        end

        expect { some_class.call(a: 42) }.to raise_error(ArgumentError)
      end

      it 'allows you to specify a default value for an argument' do
        some_class = Class.new do
          include Verbal

          input :a, :b

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
    end

    context 'without_arguments' do
      it 'still does something' do
        some_class = Class.new do
          include Verbal

          def call
            :some_behavior
          end
        end

        _outcome, value = some_class.call

        expect(value).to eql(:some_behavior)
      end
    end
  end
end
