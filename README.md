# Verbalize

[![Build Status](https://circleci.com/gh/taylorzr/verbalize.svg?style=shield&circle-token=58dcd03ffacd1c21e57766a0fba6b2008bafd777)](https://circleci.com/gh/taylorzr/verbalize/tree/master) [![Coverage Status](https://coveralls.io/repos/github/taylorzr/verbalize/badge.svg?branch=master)](https://coveralls.io/github/taylorzr/verbalize?branch=master)

## Usage

```ruby
class Add
  include Verbalize

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

outcome, value = Add.call(a: 35, b: 7)
outcome # => :ok
value # => 42
```

```ruby
class Add
  include Verbalize

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

```ruby
class Divide
  include Verbalize

  input :a, :b

  def call
    fail! 'You can’t divide by 0' if b == 0
    a / b
  end
end

result = Divide.call(a: 1, b: 0) # => [:error, 'You can’t divide by 0']
result.failed? # => true
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
  include Verbalize

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

