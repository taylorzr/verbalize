require_relative 'build_method_base'

module Verbalize
  class BuildSafeActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      if all_keywords.empty?
        "  __verbalized_send(:#{method_name})"
      else
        "  __verbalized_send(:#{method_name}, #{initialize_keywords_and_values})"
      end
    end
  end
end
