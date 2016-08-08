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
result.failed? # => false

outcome, value = Add.call(a: 35, b: 7)
outcome # => :ok
value # => 42
```

```ruby
class Add
  include Verbalize

  input :a, :b

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
```

```ruby
class VerbalizeAdd
  include Verbalize

  input :a, :b

  def call
    a + b
  end
end
```

```ruby
class ActionizerAdd
  include Actionizer

  def call
    output.sum = input.a + input.b
  end
end
```

```ruby
class InteractorAdd
  include Interactor

  def call
    context.sum = context.a + context.b
  end
end
```

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report('Ruby')       { RubyAdd.call(a: 1, b: 2) }
  x.report('Verbal')     { VerbalAdd.call(a: 1, b: 2) }
  x.report('Actionizer') { ActionizerAdd.call(a: 1, b: 2) }
  x.report('Interactor') { InteractorAdd.call(a: 1, b: 2) }
  x.compare!
end
```

```
Calculating -------------------------------------
          Interactor      4619 i/100ms
          Actionizer      4919 i/100ms
           Verbalize     21841 i/100ms
                Ruby     43212 i/100ms
-------------------------------------------------
          Interactor    46966.6 (±7.5%) i/s -     235569 in   5.046586s
          Actionizer    48493.5 (±6.0%) i/s -     245950 in   5.091045s
           Verbalize   259273.2 (±4.7%) i/s -    1310460 in   5.065844s
                Ruby   618459.0 (±5.4%) i/s -    3111264 in   5.046011s

Comparison:
                Ruby:   618459.0 i/s
           Verbalize:   259273.2 i/s - 2.39x slower
          Actionizer:    48493.5 i/s - 12.75x slower
          Interactor:    46966.6 i/s - 13.17x slower
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

