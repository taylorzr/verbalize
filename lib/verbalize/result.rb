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
      warn Kernel.caller.first + ': `Verbalize::Result#value` is deprecated; use `Verbalize::Failure#error` or ' \
        '`Verbalize::Success#value` instead.  It will be removed from `Verbalize::Result` in Verbalize version 2.0'
      @value
    end
  end
end
