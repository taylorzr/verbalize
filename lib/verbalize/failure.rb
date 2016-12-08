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
  end
end
