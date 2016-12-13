require_relative 'build_method_base'

module Verbalize
  class BuildDangerousActionMethod < BuildMethodBase
    private

    def declaration
      declare('self.call!')
    end

    def body
      if all_keywords.empty?
        '  __verbalized_send!'
      else
        "  __verbalized_send!(#{initialize_keywords_and_values})"
      end
    end
  end
end
