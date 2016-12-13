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
      raise NotImplementedError, 'Subclasses must override Verbalize::Result#value'
    end
  end
end
