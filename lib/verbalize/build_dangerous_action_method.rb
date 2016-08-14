require_relative 'build_method_base'

module Verbalize
  class BuildDangerousActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}!(#{declaration_keyword_arguments})"
    end

    def body
      "new(#{initialize_keyword_arguments}).send(:call)"
    end

    def initialize_keyword_arguments
      all_keywords.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
