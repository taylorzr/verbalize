require_relative 'build_method_base'

module Verbalize
  class BuildDangerousActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}!(#{declaration_keyword_arguments})"
    end

    def body
      "  new(#{initialize_keywords_and_values}).send(:#{method_name})"
    end
  end
end
