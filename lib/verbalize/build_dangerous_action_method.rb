require_relative 'build_method_base'

module Verbalize
  class BuildDangerousActionMethod < BuildMethodBase
    private

    def declaration
      "def self.#{method_name}!(#{declaration_keyword_arguments})"
    end

    def body
      <<-BODY.chomp
  new(#{initialize_keywords_and_values}).send(:#{method_name})
rescue UncaughtThrowError => uncaught_throw_error
  error = VerbalizeError.new("Unhandled fail! called with: \#{uncaught_throw_error.value.value.inspect}.")
  error.set_backtrace(uncaught_throw_error.backtrace[2..-1])
  raise error
      BODY
    end
  end
end
