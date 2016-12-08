require_relative 'result'

module Verbalize
  class Success < Result
    def initialize(value)
      super(outcome: :ok, value: value)
    end

    attr_reader :value
  end
end
