require_relative 'build_method_base'

module Verbalize
  class BuildDangerousActionMethod < BuildMethodBase
    private

    def declaration
      declare('self.call!')
    end

    def body
      verbalized_send_string(bang: true)
    end
  end
end
