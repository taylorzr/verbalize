require 'spec_helper'

describe Verbalize::BuildInitializeMethod do
  describe '#build' do
    it 'builds a method string with no keywords' do
      result = described_class.call

      expect(result).to eql(<<-METHOD)
def initialize()
end
      METHOD
    end

    it 'builds a method string with one keyword' do
      result = described_class.call(required_keywords: [:some_keyword])

      expect(result).to eql(<<-METHOD)
def initialize(some_keyword:)
  @some_keyword = some_keyword
end
      METHOD
    end

    it 'builds a method string with multiple keywords' do
      result = described_class.call(
        required_keywords: [:some_argument_1, :some_argument_2]
      )

      expect(result).to eql(<<-METHOD)
def initialize(some_argument_1:, some_argument_2:)
  @some_argument_1 = some_argument_1
  @some_argument_2 = some_argument_2
end
      METHOD
    end
  end
end
