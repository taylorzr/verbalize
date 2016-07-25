require 'spec_helper'

describe Verbal::BuildAttributes do
  subject(:attribute_builder) { described_class.new(arguments, keyword_arguments) }

  let(:arguments)         { [] }
  let(:keyword_arguments) { {} }

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

  context 'with 1 keyword argument' do
    let(:keyword_arguments) { { some_keyword: :some_default } }

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_keyword
        ATTRIBUTES
      )
    end
  end

  context 'with multiple keyword arguments' do
    let(:keyword_arguments) do
      { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
    end

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_keyword_1, :some_keyword_2
        ATTRIBUTES
      )
    end
  end

  context 'with 1 argument, and 1 keyword argument' do
    let(:arguments)         { [:some_argument] }
    let(:keyword_arguments) { { some_keyword: :some_default } }

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_argument, :some_keyword
        ATTRIBUTES
      )
    end
  end

  context 'with multiple arguments, and multiple keyword arguments' do
    let(:arguments) { [:some_argument_1, :some_argument_2] }
    let(:keyword_arguments) do
      { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
    end

    it do
      attributes_string = attribute_builder.build

      expect(attributes_string). to eql(
        <<-ATTRIBUTES.gsub(/^\s*/, '').chomp
          attr_accessor :some_argument_1, :some_argument_2, :some_keyword_1, :some_keyword_2
        ATTRIBUTES
      )
    end
  end
end
