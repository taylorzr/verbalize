require 'verbalize/version'
require 'verbalize/action'

module Verbalize
  # Remove this in a later version of Verbalize if desired.  Aliased here for backwards compatibility.
  THROWN_SYMBOL = Action::THROWN_SYMBOL

  def self.included(target)
    warn Kernel.caller.first + ': `include Verbalize` is deprecated and will be removed in Verbalize v3.0; ' \
                                          'include `Verbalize::Action` instead'
    target.include Verbalize::Action
  end
end
