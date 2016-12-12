require 'spec_helper'

describe Verbalize do
  describe '.verbalize' do
    it 'returns a Verbalize::Failure instance on fail!' do
      some_class = Class.new do
        include Verbalize

        def call
          fail!('Some error')
        end
      end

      expect(some_class.call).to be_an_instance_of(Verbalize::Failure)
    end

    it 'returns a Verbalize::Success instance on success' do
      some_class = Class.new do
        include Verbalize

        def call
          true
        end
      end

      expect(some_class.call).to be_an_instance_of(Verbalize::Success)
    end

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

        result = some_class.call(a: 40, b: 2)

        expect(result).to be_success
        expect(result.value).to eql(42)
      end

      it 'allows class & instance method to be named differently' do
        some_class = Class.new do
          include Verbalize

          verbalize :some_method_name

          def some_method_name
            :some_method_result
          end
        end

        result = some_class.some_method_name

        expect(result).to be_success
        expect(result.value).to eql(:some_method_result)
      end

      it 'raises an error when you don’t specify a required argument' do
        some_class = Class.new do
          include Verbalize

          input :a, :b

          def call; end
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

        result = some_class.call(a: 40)

        expect(result).to be_success
        expect(result.value).to eql(42)
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

        result = some_class.call(a: 1, b: 0)

        expect(result).not_to be_success
        expect(result).to be_failed
        expect(result.value).to eql('Are you crazy?!? You can’t divide by zero!')
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

        result = some_class.call

        expect(result).to be_success
        expect(result.value).to eql(:some_behavior)
      end

      it 'allows you to fail an action and not execute remaining lines' do
        some_class = Class.new do
          include Verbalize

          def call
            fail! 'Are you crazy?!? You can’t divide by zero!'
            1 / 0
          end
        end

        result = some_class.call

        expect(result).to be_failed
        expect(result.value).to eql('Are you crazy?!? You can’t divide by zero!')
      end

      it 'raises an error if you specify unrecognized keyword/value arguments' do
        expect do
          Class.new do
            include Verbalize

            input improper: :usage
          end
        end.to raise_error(ArgumentError)
      end
    end

    it 'fails up to a parent action' do
      some_inner_class = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      some_outer_class = Class.new do
        include Verbalize
      end

      some_outer_class.class_exec(some_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      result = some_outer_class.call

      expect(result).not_to   be_success
      expect(result).to       be_failed
      expect(result.value).to eq :some_failure_message
    end

    it 'stubbed failures are captured by parent actions' do
      some_inner_class = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      some_outer_class = Class.new do
        include Verbalize
      end

      some_outer_class.class_exec(some_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      allow(some_inner_class).to receive(:call!).and_throw(Verbalize::THROWN_SYMBOL, 'foo error')

      result = some_outer_class.call

      expect(result).not_to   be_success
      expect(result).to       be_failed
      expect(result.value).to eq 'foo error'
    end

    it 'fails up multiple levels' do
      some_inner_inner_class = Class.new do
        include Verbalize

        def call
          fail! :some_failure_message
        end
      end

      some_inner_class = Class.new do
        include Verbalize
      end

      some_inner_class.class_exec(some_inner_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      some_outer_class = Class.new do
        include Verbalize
      end

      some_outer_class.class_exec(some_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      outcome, value = some_outer_class.call

      expect(outcome).to eq :error
      expect(value).to   eq :some_failure_message
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

    it 're-raises uncaught throw errors that do not use verbalize throw tag' do
      some_class = Class.new do
        include Verbalize

        input :a, :b

        def call
          throw :nonverbalizethrow
        end
      end

      expect {
        some_class.call(a: 1, b: 0)
      }.to raise_error(UncaughtThrowError, 'uncaught throw :nonverbalizethrow')
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
      some_inner_class = Class.new do
        include Verbalize

        input :a, :b

        def call
          fail! :some_failure_message if b.zero?
        end
      end

      some_outer_class = Class.new do
        include Verbalize
      end

      some_outer_class.class_exec(some_inner_class) do |interactor_class|
        input :a, :b

        define_method(:call) do
          interactor_class.call!(a: a, b: b)
        end
      end

      outcome, value = some_outer_class.call(a: 1, b: 0)

      expect(outcome).to eq :error
      expect(value).to   eq :some_failure_message
    end
  end
end
