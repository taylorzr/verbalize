require_relative 'build_method_base'

module Verbalize
  class BuildInitializeMethod < BuildMethodBase
    private

    def declaration
      "def initialize(#{declaration_keyword_arguments})"
    end

    def body
      return if all_keywords.empty?

      lines = all_keywords.map do |keyword|
        "@#{keyword} = #{keyword}"
      end

      lines.join("\n")
    end
  end
end
