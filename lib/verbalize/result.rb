module Verbalize
  class Result < Array
    def initialize(outcome:, value:)
      super([outcome, value])
    end

    def succeeded?
      !failed?
    end
    alias_method :success?, :succeeded?

    def failed?
      outcome == :error
    end

    def outcome
      first
    end

    def value
      last
    end
  end
end
