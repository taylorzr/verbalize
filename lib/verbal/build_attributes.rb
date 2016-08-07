module Verbal
  class BuildAttributes
    def initialize(keywords)
      @keywords = keywords
    end

    def build
      return '' if keywords.empty?
      "attr_reader #{keywords.map(&:inspect).join ', '}"
    end

    private

    attr_reader :keywords
  end
end
