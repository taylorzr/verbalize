module Verbalize
  class BuildAttributes
    def initialize(attributes: [])
      @attributes = attributes
    end

    def build
      return '' if attributes.empty?
      "attr_reader #{attributes.map(&:inspect).join ', '}"
    end

    private

    attr_reader :attributes
  end
end
