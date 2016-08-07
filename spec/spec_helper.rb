require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'verbalize'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # This option should be set when all dependencies are being loaded
    # before a spec run, as is the case in a typical spec helper. It will
    # cause any verifying double instantiation for a class that does not
    # exist to raise, protecting against incorrectly spelt names.
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
