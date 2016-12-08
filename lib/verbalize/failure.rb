require_relative 'result'

module Verbalize
  class Failure < Result
    def initialize(error)
      super(outcome: :error, value: error)
    end
  end
end
