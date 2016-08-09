module Verbalize
  class BuildAttributes
    def self.call(attributes: [])
      new(attributes: attributes).call
    end

    def initialize(attributes: [])
      @attributes = attributes
    end

    def call
      return '' if attributes.empty?
      "attr_reader #{attributes.map(&:inspect).join ', '}"
    end

    private

    attr_reader :attributes
  end
end
