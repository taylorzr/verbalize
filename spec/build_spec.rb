require 'spec_helper'
require 'verbalize/action'

describe Verbalize::Build do
  context 'with required input only' do
    it 'builds an action with one required argument' do
      result = described_class.call([:required_argument])

      expect(result).to eql \
        <<-CODE
class << self
  def call(required_argument:)
    __proxied_call(required_argument: required_argument)
  end

  def call!(required_argument:)
    __proxied_call!(required_argument: required_argument)
  end
  alias_method :!, :call!
end

def initialize(required_argument:)
  __setup(:required_argument, required_argument)
end

private

attr_reader :required_argument
      CODE
    end

    it 'builds an action with multiple required arguments' do
      result = described_class.call([:required_argument_1, :required_argument_2])

      expect(result).to eql \
        <<-CODE
class << self
  def call(required_argument_1:, required_argument_2:)
    __proxied_call(required_argument_1: required_argument_1, required_argument_2: required_argument_2)
  end

  def call!(required_argument_1:, required_argument_2:)
    __proxied_call!(required_argument_1: required_argument_1, required_argument_2: required_argument_2)
  end
  alias_method :!, :call!
end

def initialize(required_argument_1:, required_argument_2:)
  __setup(:required_argument_1, required_argument_1)
  __setup(:required_argument_2, required_argument_2)
end

private

attr_reader :required_argument_1, :required_argument_2
      CODE
    end
  end

  context 'with optional input only' do
    it 'builds an action with one required argument' do
      result = described_class.call([], [:optional_argument])

      expect(result).to eql \
        <<-CODE
class << self
  def call(optional_argument: nil)
    __proxied_call(optional_argument: optional_argument)
  end

  def call!(optional_argument: nil)
    __proxied_call!(optional_argument: optional_argument)
  end
  alias_method :!, :call!
end

def initialize(optional_argument: nil)
  __setup(:optional_argument, optional_argument)
end

private

attr_reader :optional_argument
      CODE
    end

    it 'builds an action with multiple optional arguments' do
      result = described_class.call([], [:optional_argument_1, :optional_argument_2])

      expect(result).to eql \
        <<-CODE
class << self
  def call(optional_argument_1: nil, optional_argument_2: nil)
    __proxied_call(optional_argument_1: optional_argument_1, optional_argument_2: optional_argument_2)
  end

  def call!(optional_argument_1: nil, optional_argument_2: nil)
    __proxied_call!(optional_argument_1: optional_argument_1, optional_argument_2: optional_argument_2)
  end
  alias_method :!, :call!
end

def initialize(optional_argument_1: nil, optional_argument_2: nil)
  __setup(:optional_argument_1, optional_argument_1)
  __setup(:optional_argument_2, optional_argument_2)
end

private

attr_reader :optional_argument_1, :optional_argument_2
      CODE
    end
  end

  context 'with required and optional input' do
    it 'builds an action with one required argument and one optional argument' do
      result = described_class.call([:required_argument], [:optional_argument])

      expect(result).to eql \
        <<-CODE
class << self
  def call(required_argument:, optional_argument: nil)
    __proxied_call(required_argument: required_argument, optional_argument: optional_argument)
  end

  def call!(required_argument:, optional_argument: nil)
    __proxied_call!(required_argument: required_argument, optional_argument: optional_argument)
  end
  alias_method :!, :call!
end

def initialize(required_argument:, optional_argument: nil)
  __setup(:required_argument, required_argument)
  __setup(:optional_argument, optional_argument)
end

private

attr_reader :required_argument, :optional_argument
      CODE
    end

    it 'builds an action with multiple required  and optional arguments' do
      result = described_class.call(
        [:required_argument_1, :required_argument_2],
        [:optional_argument_1, :optional_argument_2]
      )

      expect(result).to eql \
        <<-CODE
class << self
  def call(required_argument_1:, required_argument_2:, optional_argument_1: nil, optional_argument_2: nil)
    __proxied_call(required_argument_1: required_argument_1, required_argument_2: required_argument_2, optional_argument_1: optional_argument_1, optional_argument_2: optional_argument_2)
  end

  def call!(required_argument_1:, required_argument_2:, optional_argument_1: nil, optional_argument_2: nil)
    __proxied_call!(required_argument_1: required_argument_1, required_argument_2: required_argument_2, optional_argument_1: optional_argument_1, optional_argument_2: optional_argument_2)
  end
  alias_method :!, :call!
end

def initialize(required_argument_1:, required_argument_2:, optional_argument_1: nil, optional_argument_2: nil)
  __setup(:required_argument_1, required_argument_1)
  __setup(:required_argument_2, required_argument_2)
  __setup(:optional_argument_1, optional_argument_1)
  __setup(:optional_argument_2, optional_argument_2)
end

private

attr_reader :required_argument_1, :required_argument_2, :optional_argument_1, :optional_argument_2
      CODE
    end
  end

  context 'with default inputs' do
    it 'builds an action with just default arguments' do
      result = described_class.call([], [], [:default1, :default2])

      expect(result).to eql \
        <<-CODE
class << self
  def call(default1: self.defaults[:default1].call, default2: self.defaults[:default2].call)
    __proxied_call(default1: default1, default2: default2)
  end

  def call!(default1: self.defaults[:default1].call, default2: self.defaults[:default2].call)
    __proxied_call!(default1: default1, default2: default2)
  end
  alias_method :!, :call!
end

def initialize(default1: self.defaults[:default1].call, default2: self.defaults[:default2].call)
  __setup(:default1, default1)
  __setup(:default2, default2)
end

private

attr_reader :default1, :default2
      CODE
    end
  end

  context 'with a required, optional, and default input' do
    it 'builds an action with optional and default arguments' do
      result = described_class.call([:req1], [:opt1], [:default])

      expect(result).to eql \
        <<-CODE
class << self
  def call(req1:, opt1: nil, default: self.defaults[:default].call)
    __proxied_call(req1: req1, opt1: opt1, default: default)
  end

  def call!(req1:, opt1: nil, default: self.defaults[:default].call)
    __proxied_call!(req1: req1, opt1: opt1, default: default)
  end
  alias_method :!, :call!
end

def initialize(req1:, opt1: nil, default: self.defaults[:default].call)
  __setup(:req1, req1)
  __setup(:opt1, opt1)
  __setup(:default, default)
end

private

attr_reader :req1, :opt1, :default
      CODE
    end
  end
end
