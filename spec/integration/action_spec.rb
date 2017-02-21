require 'verbalize/action'

describe Verbalize::Action do
  let(:a) { double(divide_by: 20) }

  let(:simple_action) do
    Class.new do
      include Verbalize::Action

      input :a, :b

      def call
        fail! 'Are you crazy?!? You can’t divide by zero!' if b == 0
        a.divide_by(b)
      end
    end
  end

  describe '.call' do
    it 'returns a Verbalize::Failure instance on fail!' do
      result = simple_action.call(a: a, b: 0)

      expect(result).to         be_an_instance_of Verbalize::Failure
      expect(result).to         be_failure
      expect(result.failure).to eq 'Are you crazy?!? You can’t divide by zero!'
    end

    it 'returns a Verbalize::Success instance on success' do
      result = simple_action.call(a: a, b: 10)

      expect(result).to       be_an_instance_of Verbalize::Success
      expect(result).to       be_success
      expect(result.value).to eq 20
    end

    it 'short circuits the call block on failure' do
      simple_action.call(a: a, b: 0)

      expect(a).not_to have_received(:divide_by)
    end

    it 'stubbed failures return a Verbalize::Failure' do
      allow(simple_action).to receive(:perform).and_throw(described_class::THROWN_SYMBOL, 'foo error')

      result = simple_action.call(a: a, b: 10)

      expect(result).to         be_an_instance_of Verbalize::Failure
      expect(result).to         be_failed
      expect(result.failure).to eq 'foo error'
    end

    it 'stubbed success return a Verbalize::Success' do
      allow(simple_action).to receive(:perform).and_return(123)

      result = simple_action.call(a: a, b: 10)

      expect(result).to       be_an_instance_of Verbalize::Success
      expect(result).to       be_success
      expect(result.value).to eq 123
    end

    it 'catches failures thrown up multiple levels' do
      some_inner_inner_class = Class.new do
        include Verbalize::Action

        def call
          fail! :some_failure_message
        end
      end

      some_inner_class = Class.new do
        include Verbalize::Action
      end

      some_inner_class.class_exec(some_inner_inner_class) do |action_class|
        define_method(:call) do
          action_class.call!
        end
      end

      some_outer_class = Class.new do
        include Verbalize::Action
      end

      some_outer_class.class_exec(some_inner_class) do |action_class|
        define_method(:call) do
          action_class.call!
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

      some_outer_class.class_exec(some_inner_class) do |action_class|
        define_method(:call) do
          action_class.call!
        end
      end

      result = some_outer_class.call

      expect(result).not_to     be_success
      expect(result).to         be_failed
      expect(result.failure).to eq :some_failure_message
    end

    it 'stubbed failures raise a Verbalize::Error when using `call!`' do
      some_action = Class.new do
        include Verbalize::Action
      end

      allow(some_action).to receive(:perform).and_throw(described_class::THROWN_SYMBOL, 'foo error')

      expect do
        some_action.call!
      end.to raise_error(Verbalize::Error, 'Unhandled fail! called with: "foo error".')
    end

    it 'stubbed success returns the resulting value directly' do
      allow(simple_action).to receive(:perform).and_return(123)

      result = simple_action.call!(a: a, b: 10)

      expect(result).to eq 123
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

  describe '.!' do
    it 'detects missing named parameters when stubbed' do
      allow(simple_action).to receive(:!)
      expect { simple_action.! }.to raise_error ArgumentError, 'Missing required keyword arguments: a, b'
    end

    it 'works when there are no input parameters' do
      action_class = Class.new do
        include Verbalize::Action
        def call
          2
        end
      end

      value = action_class.!
      expect(value).to eq 2
    end

    it 'works with input parameters' do
      value = simple_action.!(a: a, b: 5)
      expect(value).to eq 20
    end

    it 'throws when a failure occurs' do
      expect do
        simple_action.!(a: a, b: 0)
      end.to throw_symbol(Verbalize::THROWN_SYMBOL, 'Are you crazy?!? You can’t divide by zero!')
    end
  end

  describe '.input' do
    context 'without_arguments' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action

          def call
            :some_behavior
          end
        end
      end

      it 'delegates to the instance call method without arguments' do
        result = some_class.call

        expect(result).to be_success
        expect(result.value).to eql(:some_behavior)
      end
    end

    context 'with required arguments' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action

          input :a, :b

          def call
            a + b
          end
        end
      end

      it 'allows arguments to be defined and delegates the class method \
      to the instance method' do
        result = some_class.call(a: 40, b: 2)

        expect(result).to be_success
        expect(result.value).to eql(42)
      end

      it 'raises an error when you don’t specify a required argument' do
        expect { some_class.call(a: 42) }.to raise_error(ArgumentError)
      end
    end

    context 'with an optional argument' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action

          input :a, optional: :b

          def call
            a + b
          end

          def b
            @b ||= 2
          end
        end
      end

      it 'allows you to specify an optional argument' do
        result = some_class.call(a: 40)

        expect(result).to be_success
        expect(result.value).to eql(42)
      end
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

  describe '.required_inputs' do
    context 'with no inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
        end
      end

      it 'returns an empty array' do
        expect(some_class.required_inputs).to eq []
      end
    end

    context 'with no required inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input optional: [:a, :b]
        end
      end

      it 'returns an empty array' do
        expect(some_class.required_inputs).to eq []
      end
    end

    context 'with required inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, :b, optional: [:c, :d]
        end
      end

      it 'returns the required inputs' do
        expect(some_class.required_inputs).to contain_exactly(:a, :b)
      end
    end
  end

  describe '.optional_inputs' do
    context 'with no inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
        end
      end

      it 'returns an empty array' do
        expect(some_class.optional_inputs).to eq []
      end
    end

    context 'with no optional inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, :b
        end
      end

      it 'returns an empty array' do
        expect(some_class.optional_inputs).to eq []
      end
    end

    context 'with 1 optional input' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, optional: :b
        end
      end

      it 'returns the optional inputs' do
        expect(some_class.optional_inputs).to contain_exactly(:b)
      end
    end

    context 'with optional inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, optional: [:b, :c]
        end
      end

      it 'returns the optional inputs' do
        expect(some_class.optional_inputs).to contain_exactly(:b, :c)
      end
    end
  end

  describe '.inputs' do
    context 'with no inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
        end
      end

      it 'returns an empty array' do
        expect(some_class.inputs).to eq []
      end
    end

    context 'with optional inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input optional: [:a, :b]
        end
      end

      it 'returns an empty array' do
        expect(some_class.inputs).to contain_exactly(:a, :b)
      end
    end

    context 'with required inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, :b
        end
      end

      it 'returns an empty array' do
        expect(some_class.inputs).to contain_exactly(:a, :b)
      end
    end

    context 'with one required and one optional input' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, optional: :b
        end
      end

      it 'returns the inputs' do
        expect(some_class.inputs).to contain_exactly(:a, :b)
      end
    end

    context 'with required and optional inputs' do
      let(:some_class) do
        Class.new do
          include Verbalize::Action
          input :a, :b, optional: [:c, :d]
        end
      end

      it 'returns the inputs' do
        expect(some_class.inputs).to contain_exactly(:a, :b, :c, :d)
      end
    end
  end
end
