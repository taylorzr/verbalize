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
  @required_argument = required_argument
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
  @required_argument_1 = required_argument_1
  @required_argument_2 = required_argument_2
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
  @optional_argument = optional_argument
end

private

attr_reader :optional_argument
      CODE
    end

    it 'builds an action with multiple required arguments' do
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
  @optional_argument_1 = optional_argument_1
  @optional_argument_2 = optional_argument_2
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
  @required_argument = required_argument
  @optional_argument = optional_argument
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
  @required_argument_1 = required_argument_1
  @required_argument_2 = required_argument_2
  @optional_argument_1 = optional_argument_1
  @optional_argument_2 = optional_argument_2
end

private

attr_reader :required_argument_1, :required_argument_2, :optional_argument_1, :optional_argument_2
      CODE
    end
  end
end
