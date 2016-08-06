require 'spec_helper'

describe Verbal::BuildInitialize do
  describe 'build' do
    subject(:initialize_builder) do
      described_class.new(arguments, keyword_arguments)
    end
    let(:arguments)          { [] }
    let(:keyword_arguments)  { {} }

    context 'with only a method name' do
      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize()
            end
          METHOD
        )
      end
    end

    context 'with 1 argument' do
      let(:arguments) { [:some_argument] }

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_argument: nil)
            @some_argument = some_argument
            end
          METHOD
        )
      end
    end

    context 'with multiple arguments' do
      let(:arguments) { [:some_argument_1, :some_argument_2] }

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_argument_1: nil, some_argument_2: nil)
            @some_argument_1 = some_argument_1
            @some_argument_2 = some_argument_2
            end
          METHOD
        )
      end
    end

    xcontext 'with 1 keyword argument' do
      let(:keyword_arguments) { { some_keyword: :some_default } }

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_keyword: :some_default)
            @some_keyword = some_keyword
            end
          METHOD
        )
      end
    end

    xcontext 'with multiple keyword arguments' do
      let(:keyword_arguments) do
        { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
      end

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_keyword_1: :some_default_1, some_keyword_2: :some_default_2)
            @some_keyword_1 = some_keyword_1
            @some_keyword_2 = some_keyword_2
            end
          METHOD
        )
      end
    end

    xcontext 'with 1 argument, and 1 keyword argument' do
      let(:arguments)         { [:some_argument] }
      let(:keyword_arguments) { { some_keyword: :some_default } }

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_argument:, some_keyword: :some_default)
            @some_argument = some_argument
            @some_keyword = some_keyword
            end
          METHOD
        )
      end
    end

    xcontext 'with multiple arguments, and multiple keyword arguments' do
      let(:arguments) { [:some_argument_1, :some_argument_2] }
      let(:keyword_arguments) do
        { some_keyword_1: :some_default_1, some_keyword_2: :some_default_2 }
      end

      it do
        method_string = initialize_builder.build

        expect(method_string).to eql(
          <<-METHOD.gsub(/^\s*/, '').chomp
            def initialize(some_argument_1:, some_argument_2:, some_keyword_1: :some_default_1, some_keyword_2: :some_default_2)
            @some_argument_1 = some_argument_1
            @some_argument_2 = some_argument_2
            @some_keyword_1 = some_keyword_1
            @some_keyword_2 = some_keyword_2
            end
          METHOD
        )
      end
    end
  end
end
