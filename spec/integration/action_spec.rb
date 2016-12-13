require 'verbalize/action'

describe Verbalize::Action do
  let(:a) { double(divide_by: 20) }

  let(:simple_action) do
    Class.new do
      include Verbalize::Action

      input :a, :b, :should_fail

      def call
        fail! 'Are you crazy?!? You can’t divide by zero!' if should_fail
        a.divide_by(b)
      end
    end
  end

  describe '.call' do
    it 'returns a Verbalize::Failure instance on fail!' do
      result = simple_action.call(a: a, b: 10, should_fail: true)

      expect(result).to be_an_instance_of(Verbalize::Failure)
      expect(result).to be_failure
      expect(result.failure).to eq 'Are you crazy?!? You can’t divide by zero!'
    end

    it 'returns a Verbalize::Success instance on success' do
      result = simple_action.call(a: a, b: 10, should_fail: false)

      expect(result).to be_an_instance_of(Verbalize::Success)
      expect(result).to be_success
      expect(result.value).to eq 20
    end

    it 'short circuits the call block on failure' do
      simple_action.call(a: a, b: 10, should_fail: true)

      expect(a).not_to have_received(:divide_by)
    end

    it 'stubbed failures return a Verbalize::Falure on `call`' do
      allow(simple_action).to receive(:perform).and_throw(described_class::THROWN_SYMBOL, 'foo error')

      result = simple_action.call(a: a, b: 10, should_fail: false)

      expect(result).not_to   be_success
      expect(result).to       be_failed
      expect(result.failure).to eq 'foo error'
    end

    it 'fails up multiple levels' do
      some_inner_inner_class = Class.new do
        include Verbalize::Action

        def call
          fail! :some_failure_message
        end
      end

      some_inner_class = Class.new do
        include Verbalize::Action
      end

      some_inner_class.class_exec(some_inner_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      some_outer_class = Class.new do
        include Verbalize::Action
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
  end

  describe '.call!' do
    it 'fails up to a parent action' do
      some_inner_class = Class.new do
        include Verbalize::Action

        def call
          fail! :some_failure_message
        end
      end

      some_outer_class = Class.new do
        include Verbalize::Action
      end

      some_outer_class.class_exec(some_inner_class) do |interactor_class|
        define_method(:call) do
          interactor_class.call!
        end
      end

      result = some_outer_class.call

      expect(result).not_to   be_success
      expect(result).to       be_failed
      expect(result.failure).to eq :some_failure_message
    end

    it 'stubbed failures raise a Verbalize::Error when using `call!`' do
      some_action = Class.new do
        include Verbalize::Action

        def call
          fail! :some_failure_message
        end
      end

      allow(some_action).to receive(:perform).and_throw(described_class::THROWN_SYMBOL, 'foo error')

      expect do
        some_action.call!
      end.to raise_error(Verbalize::Error, 'Unhandled fail! called with: "foo error".')
    end

    it 'raises an error with a helpful message \
    if an action fails without being handled' do
      some_class = Class.new do
        include Verbalize::Action

        def call
          fail! :some_failure_message
        end
      end

      expect do
        some_class.call!
      end.to raise_error(Verbalize::Error, 'Unhandled fail! called with: :some_failure_message.')
    end
  end

  describe '.input' do
    context 'with arguments' do
      it 'allows arguments to be defined and delegates the class method \
      to the instance method' do
        some_class = Class.new do
          include Verbalize::Action

          input :a, :b

          def call
            a + b
          end
        end

        result = some_class.call(a: 40, b: 2)

        expect(result).to be_success
        expect(result.value).to eql(42)
      end

      it 'raises an error when you don’t specify a required argument' do
        some_class = Class.new do
          include Verbalize::Action

          input :a, :b

          def call; end
        end

        expect { some_class.call(a: 42) }.to raise_error(ArgumentError)
      end

      it 'allows you to specify an optional argument' do
        some_class = Class.new do
          include Verbalize::Action

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
          include Verbalize::Action

          input :a, :b

          def call
            fail! 'Are you crazy?!? You can’t divide by zero!'
            a / b
          end
        end

        result = some_class.call(a: 1, b: 0)

        expect(result).not_to be_success
        expect(result).to be_failed
        expect(result.failure).to eql('Are you crazy?!? You can’t divide by zero!')
      end
    end

    context 'without_arguments' do
      it 'still does something' do
        some_class = Class.new do
          include Verbalize::Action

          def call
            :some_behavior
          end
        end

        result = some_class.call

        expect(result).to be_success
        expect(result.value).to eql(:some_behavior)
      end

      it 'raises an error if you specify unrecognized keyword/value arguments' do
        expect do
          Class.new do
            include Verbalize::Action

            input improper: :usage
          end
        end.to raise_error(ArgumentError)
      end
    end
  end
end
