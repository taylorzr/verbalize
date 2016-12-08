require_relative 'result'

module Verbalize
  class Success < Result
    def initialize(value)
      super(outcome: :ok, value: value)
    end

    def value
      @value
    end
  end
end
