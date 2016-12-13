require_relative 'result'
require_relative 'error'

module Verbalize
  class Failure < Result
    extend Gem::Deprecate

    def initialize(failure)
      super(outcome: :error, value: failure)
    end

    def failure
      @value
    end

    def value
      raise Verbalize::Error, 'You called #value on a Failure result.  You should never use `Verbalize::Action#call` without also ' \
        'explicitly handling potential errors.  Please use `Verbalize::Action#call!` to return a value directly on ' \
        'successful execution of an action, or handle the error case explicitly if using `#call`.'
    end
  end
end
