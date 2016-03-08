require_relative 'build_method_base'

module Verbal
  class BuildInitialize < BuildMethodBase
    private

    def declaration
      "def initialize(#{declaration_keyword_arguments})"
    end

    def body
      return if variables.empty?

      lines = variables.map do |variable|
        "@#{variable} = #{variable}"
      end

      lines.join("\n")
    end
  end
end
