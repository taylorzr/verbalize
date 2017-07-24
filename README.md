# Verbalize

[![Build Status](https://circleci.com/gh/taylorzr/verbalize.svg?style=shield&circle-token=58dcd03ffacd1c21e57766a0fba6b2008bafd777)](https://circleci.com/gh/taylorzr/verbalize/tree/master) [![Coverage Status](https://coveralls.io/repos/github/taylorzr/verbalize/badge.svg?branch=master)](https://coveralls.io/github/taylorzr/verbalize?branch=master)

## Usage

```ruby
class Add
  include Verbalize::Action

  input :a, :b

  def call
    a + b
  end
end

result = Add.call(a: 35, b: 7)
result.outcome # => :ok
result.value # => 42
result.succeeded? # => true
result.success? # alias for succeeded? => true
result.failed? # => false
result.failure? # alias for failed? => false

outcome, value = Add.call(a: 35, b: 7)
outcome # => :ok
value # => 42
```

```ruby
class Add
  include Verbalize::Action

  input optional: [:a, :b]

  def call
    a + b
  end

  private

  def a
    @a ||= 35
  end

  def b
    @b ||= 7
  end
end

Add.call # => [:ok, 42]
Add.call(a: 660, b: 6) # => [:ok, 666]
```

## Default Values

```ruby
# You can define defaults via key/value pairs, as so:
class Add
  include Verbalize::Action
  # note that these values are evaluated at load-time as they are not wrapped
  # in lambdas.
  input optional: [a: 35, b: 7]
  def call; a + b; end
end

# default values can be lazily loaded by passing in a lambda, e.g.:

class Tomorrow
  include Verbalize::Action
  input optional: [as_of: -> { Time.now }]
  def call
    as_of + 1
  end
end

start_time = Tomorrow.call!
sleep(1)
end_time = Tomorrow.call!
end_time - start_time # ~1s; the default is executed each call.
```


```ruby
class Divide
  include Verbalize::Action

  input :a, :b

  def call
    fail! 'You can’t divide by 0' if b == 0
    a / b
  end
end

result = Divide.call(a: 1, b: 0) # => [:error, 'You can’t divide by 0']
result.failed? # => true
```

### Reflection
```ruby
class Add
  include Verbalize::Action

  input :a, :b, optional: [:c, :d]

  def call
    a + b + c + d
  end

  private

  def c
    @c ||= 0
  end

  def d
    @d ||= 0
  end
end

Add.required_inputs # [:a, :b]
Add.optional_inputs # [:c, :d]
Add.inputs # [:a, :b, :c, :d]
```

## Comparison/Benchmark
```ruby
require 'verbalize'
require 'actionizer'
require 'interactor'
require 'benchmark/ips'

class RubyAdd
  def self.call(a:, b:)
    new(a: a, b: b).call
  end

  def initialize(a:, b:)
    @a = a
    @b = b
  end

  def call
    a + b
  end

  private

  attr_reader :a, :b
end

class VerbalizeAdd
  include Verbalize::Action

  input :a, :b

  def call
    a + b
  end
end

class ActionizerAdd
  include Actionizer

  def call
    output.sum = input.a + input.b
  end
end

class InteractorAdd
  include Interactor

  def call
    context.sum = context.a + context.b
  end
end

Benchmark.ips do |x|
  x.report('Ruby')       { RubyAdd.call(a: 1, b: 2) }
  x.report('Verbalize')  { VerbalizeAdd.call(a: 1, b: 2) }
  x.report('Actionizer') { ActionizerAdd.call(a: 1, b: 2) }
  x.report('Interactor') { InteractorAdd.call(a: 1, b: 2) }
  x.compare!
end
```

```
Warming up --------------------------------------
                Ruby    53.203k i/100ms
           Verbalize    27.518k i/100ms
          Actionizer     4.933k i/100ms
          Interactor     4.166k i/100ms
Calculating -------------------------------------
                Ruby    544.025k (±13.7%) i/s -      2.660M in   5.011207s
           Verbalize    278.738k (± 8.0%) i/s -      1.403M in   5.074676s
          Actionizer     49.571k (± 7.0%) i/s -    246.650k in   5.006194s
          Interactor     45.896k (± 7.1%) i/s -    229.130k in   5.018389s

Comparison:
                Ruby:   544025.0 i/s
           Verbalize:   278737.9 i/s - 1.95x  slower
          Actionizer:    49571.1 i/s - 10.97x  slower
          Interactor:    45896.1 i/s - 11.85x  slower

```

## Testing

### Happy Path

When testing positive cases of a `Verbalize::Action`, it is recommended to test using the `call!` class method and
assert on the result.  This implicitly ensures a successful result, and your tests will fail with a bang! if
something goes wrong:

```ruby
class MyAction
  include Verbalize::Action

  input :a

  def call
    fail!('#{a} is greater than than 100!') if a >= 100
    a + 1
  end
end

it 'returns the expected result' do
  result = MyAction.call!(a: 50)
  expect(result).to eq 51
end
```

### Sad Path

When testing negative cases of a `Verbalize::Action`, it is recommended to test using the `call` non-bang
class method which will return a `Verbalize::Failure` on failure.

Use of `call!` here is not advised as it will result in an exception being thrown. Set assertions on both
the failure outcome and value:

```ruby
class MyAction
  include Verbalize::Action

  input :a

  def call
    fail!('#{a} is greater than 100!') if a >= 100
    a + 1
  end
end

# rspec:
it 'fails when the input is out of bounds' do
  result = MyAction.call(a: 1000)

  expect(result).to be_failed
  expect(result.failure).to eq '1000 is greater than 100!'
end
```

### Stubbing Responses

When unit testing, it may be necessary to stub the responses of Verbalize actions.  To correctly stub responses,
you should __always__ stub the `MyAction.perform` class method on the action class being stubbed per the
instructions below.  __Never__ stub the `call` or `call!` methods directly.

Stubbing `.perform` will enable `Verbalize` to wrap results correctly for references to either `call` or `call!`.

#### Stubbing Successful Responses

To simulate a successful response of the `Verbalize::Action` being stubbed, you should stub the `MyAction.perform`
class method to return the __value__ you expect the `MyAction#call` instance method to return.

For example, if you expect the action to return the value `123` on success:

```ruby
class Foo
  def self.multiply_by(multiple)
    result = MyAction.call(a: 1)
    raise "I couldn't do the thing!" if result.failure?

    result.value * multiple
  end
end

# rspec:
describe Foo do
  describe '#something' do
    it 'does the thing when MyAction succeeds' do
      # Simulate the successful result
      allow(MyAction).to receive(:perform)
        .with(a: 1)
        .and_return(123)

      result = described_class.multiply_by(100)

      expect(result).to eq 12300
    end
  end
end
```

#### Stubbing Failure Responses

To simulate a __failure__ response of the `Verbalize::Action` being stubbed, you should stub the `MyAction.perform`
class method to __throw__ `::Verbalize::THROWN_SYMBOL` with the __message__ you expect `MyAction#call` to throw
when the simulated failure occurs.

For example, when you expect the outer class to raise an exception when MyAction fails:

```ruby
# See also: Foo class definition in Stubbing Successful Responses above

# rspec:
describe Foo do
  describe '#multiply_by' do
    it 'raises an error when MyAction fails' do
      # Simulate the failure
      allow(MyAction).to receive(:perform)
        .with(a: 1)
        .and_throw(::Verbalize::THROWN_SYMBOL, 'Y U NO!')

      expect {
        described_class.multiply_by(100)
      }.to raise_error "I couldn't do the thing!"
    end
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'verbalize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verbalize

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taylorzr/verbalize.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
