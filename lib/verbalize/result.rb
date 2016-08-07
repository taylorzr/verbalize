module Verbalize
  class Result < Array
    def initialize(outcome:, value:)
      super([outcome, value])
    end

    def succeeded?
      !failed?
    end

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
