module Verbal
  class BuildAttributes
    def initialize(arguments, keyword_arguments)
      @arguments         = arguments
      @keyword_arguments = keyword_arguments
    end

    def build
      "attr_accessor #{attributes.join ', '}"
    end

    private

    attr_reader :arguments, :keyword_arguments

    def attributes
      (arguments + keyword_arguments.keys).map(&:inspect)
    end
  end
end
