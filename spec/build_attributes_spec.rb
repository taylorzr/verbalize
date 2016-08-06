require 'spec_helper'

describe Verbal::BuildAttributes do
  subject(:attribute_builder) { described_class.new(arguments) }

  let(:arguments) { [] }

  context 'with no arguments' do
    it
  end

  context 'with 1 argument' do
    let(:arguments) { [:some_argument] }

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_argument
        ATTRIBUTES
      )
    end
  end

  context 'with multiple arguments' do
    let(:arguments) { [:some_argument_1, :some_argument_2] }

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_argument_1, :some_argument_2
        ATTRIBUTES
      )
    end
  end
end
