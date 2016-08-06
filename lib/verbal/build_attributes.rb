module Verbal
  class BuildAttributes
    def initialize(arguments)
      @arguments = arguments
    end

    def build
      return unless arguments
      "attr_accessor #{arguments.map(&:inspect).join ', '}"
    end

    private

    attr_reader :arguments
  end
end
