require_relative 'build_method_base'

module Verbalize
  class BuildSafeActionMethod < BuildMethodBase
    private

    def declaration
      "def self.call(#{declaration_keyword_arguments})"
    end

    def body
      if all_keywords.empty?
        '  __verbalized_send'
      else
        "  __verbalized_send(#{initialize_keywords_and_values})"
      end
    end
  end
end
