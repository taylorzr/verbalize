require_relative 'result'

module Verbalize
  class Success < Result
    def initialize(value)
      super(outcome: :ok, value: value)
    end

    attr_reader :value

    def and_then
      yield value
    end

    def unwrap!
      value
    end
  end
end
