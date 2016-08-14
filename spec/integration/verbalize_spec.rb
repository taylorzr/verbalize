require 'spec_helper'

describe Verbalize do
  describe '.verbalize' do
    context 'with arguments' do
      it 'allows arguments to be defined and delegates the class method \
      to the instance method' do
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

      it 'allows class & instance method to be named differently' do
        some_class = Class.new do
          include Verbalize

          verbalize :some_method_name

          def some_method_name
            :some_method_result
          end
        end

        _outcome, value = some_class.some_method_name

        expect(value).to eql(:some_method_result)
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

      it 'raises an error if you specify unrecognize keyword/value arguments' do
        expect do
          Class.new do
            include Verbalize

            input improper: :usage
          end
        end.to raise_error(ArgumentError)
      end
    end

    it 'fails up to a parent action' do
      SomeInnerClass = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      some_outer_class = Class.new do
        include Verbalize

        def call
          SomeInnerClass.call!
        end
      end

      expect(some_outer_class.call).to eql([:error, :some_failure_message])
    end

    it 'fails up multiple levels' do
      SomeInnerInnerClass = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      SomeInnerClass = Class.new do
        include Verbalize

        def call
          SomeInnerInnerClass.call!
        end
      end

      some_outer_class = Class.new do
        include Verbalize

        def call
          SomeInnerClass.call!
        end
      end

      expect(some_outer_class.call).to eql([:error, :some_failure_message])
    end

    it 'raises an error with a helpful message \
    if an action fails without being handled' do
      some_class = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      expect { some_class.call! }.to raise_error(
        Verbalize::VerbalizeError, 'Unhandled fail! called with: :some_failure_message.'
      )
    end

    it 'raises an error with a helpful message if an action with keywords \
    fails without being handled' do
      some_class = Class.new do
        include Verbalize

        input :a, :b

        def call
          fail! :some_failure_message if b.zero?
        end
      end

      expect { some_class.call!(a: 1, b: 0) }.to raise_error(
        Verbalize::VerbalizeError, 'Unhandled fail! called with: :some_failure_message.'
      )
    end

    it 'fails up to a parent action with keywords' do
      SomeInnerClass = Class.new do
        include Verbalize

        input :a, :b

        def call
          fail! :some_failure_message if b.zero?
        end
      end

      some_outer_class = Class.new do
        include Verbalize

        input :a, :b

        def call
          SomeInnerClass.call!(a: a, b: b)
        end
      end

      expect(some_outer_class.call(a: 1, b: 0)).to eql([:error, :some_failure_message])
    end
  end
end
