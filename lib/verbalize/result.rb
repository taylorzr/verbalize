module Verbalize
  class Result
    def initialize(outcome:, value:)
      @outcome = outcome
      @value   = value
    end

    attr_reader :outcome

    def succeeded?
      !failed?
    end
    alias_method :success?, :succeeded?

    def failed?
      outcome == :error
    end
    alias_method :failure?, :failed?

    def to_ary
      [outcome, @value]
    end

    def value
      warn Kernel.caller.first + ': `Verbalize::Result#value` is deprecated and will be removed in Verbalize 2.0. '\
        'Use `Verbalize::Failure#error` or `Verbalize::Success#value` instead.'
      @value
    end
  end
end
