require_relative 'result'

module Verbalize
  class Failure < Result
    extend Gem::Deprecate

    def initialize(error)
      super(outcome: :error, value: error)
    end

    def error
      @value
    end

    def value
      warn Kernel.caller.first + ': `Verbalize::Result#value` is deprecated; use `Verbalize::Failure#error` instead for failed results.  It will be removed in Verbalize version 2.0'
      @value
    end
  end
end
