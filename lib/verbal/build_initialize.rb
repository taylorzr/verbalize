require_relative 'build_method_base'

module Verbal
  class BuildInitialize < BuildMethodBase
    private

    def declaration
      "def initialize(#{declaration_keyword_arguments})"
    end

    def body
      return if keywords.empty?

      lines = keywords.map do |keyword|
        "@#{keyword} = #{keyword}"
      end

      lines.join("\n")
    end
  end
end
