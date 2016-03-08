require_relative 'build_method_base'

module Verbal
  class BuildAction < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      "self.new(#{initialize_keyword_arguments}).#{method_name}"
    end

    def initialize_keyword_arguments
      variables.map { |variable| "#{variable}: #{variable}" }.join(', ')
    end
  end
end
