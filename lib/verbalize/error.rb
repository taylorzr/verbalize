module Verbalize
  VerbalizeError = Class.new(StandardError)
  # alias Verbalize::Error to Verbalize::VerbalizeError for now, for backwards compatibility
  Error = Class.new(VerbalizeError)
end
