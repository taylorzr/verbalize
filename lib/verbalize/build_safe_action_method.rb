require_relative 'build_method_base'

module Verbalize
  class BuildSafeActionMethod < BuildMethodBase
    private

    def declaration
      declare('self.call')
    end

    def body
      verbalized_send_string(bang: false)
    end
  end
end
