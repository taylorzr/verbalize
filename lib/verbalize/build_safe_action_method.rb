require_relative 'build_method_base'

module Verbalize
  class BuildSafeActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}(#{declaration_keyword_arguments})"
    end

    def body
      <<-BODY.chomp
  action = new(#{initialize_keywords_and_values})
  result = catch(:verbalize_error) { action.send(#{method_name.inspect}) }
  if result.is_a?(Result)
    result
  else
    Result.new(outcome: :ok, value: result)
  end
      BODY
    end
  end
end
