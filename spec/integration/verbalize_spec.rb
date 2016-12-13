require 'verbalize'

describe Verbalize do
  it 'emits a deprecation warning on include' do
    expected_message = Regexp.compile('`include Verbalize` is deprecated and will be removed in Verbalize v3.0; ' \
                                          'include `Verbalize::Action` instead')
    expect do
      Class.new do
        include Verbalize
      end
    end.to output(expected_message).to_stderr
  end

  it 'includes Verbalize::Action into the target' do
    action_class = Class.new do
      include Verbalize
    end
    expect(action_class.ancestors).to include Verbalize::Action
  end
end
