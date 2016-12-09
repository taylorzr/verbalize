require_relative 'result'

module Verbalize
  class Failure < Result
    extend Gem::Deprecate

    def initialize(error)
      super(outcome: :error, value: error)
    end

    def failure
      @value
    end

    def value
      warn Kernel.caller.first + ': `Verbalize::Failure#value` is deprecated; use `Verbalize::Failure#failure` '\
        'instead when explicitly handling failures. `Verbalize::Failure#value` will raise an exception in Verbalize '\
        '2.0 to prevent accidental use of `#value` on failure results without explicit error handling. '
      @value
    end
  end
end
