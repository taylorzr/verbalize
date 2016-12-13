module Verbalize
  class BuildMethodBase
    def self.call(required_keywords: [], optional_keywords: [])
      new(
        required_keywords: required_keywords,
        optional_keywords: optional_keywords
      ).call
    end

    def initialize(required_keywords: [], optional_keywords: [])
      @required_keywords = required_keywords
      @optional_keywords = optional_keywords
    end

    def call
      parts.compact.join "\n"
    end

    private

    attr_reader :required_keywords, :optional_keywords

    def parts
      [declaration, body, "end\n"]
    end

    def declaration
      raise NotImplementedError
    end

    def body
      raise NotImplementedError
    end

    def declare(method_name)
      "def #{method_name}(#{declaration_keyword_arguments})"
    end

    def all_keywords
      required_keywords + optional_keywords
    end

    def required_keyword_segments
      required_keywords.map { |keyword| "#{keyword}:" }
    end

    def optional_keyword_segments
      optional_keywords.map { |keyword| "#{keyword}: nil" }
    end

    def declaration_keyword_arguments
      return if all_keywords.empty?
      (required_keyword_segments + optional_keyword_segments).join(', ')
    end

    def initialize_keywords_and_values
      all_keywords.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
