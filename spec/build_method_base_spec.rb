require 'verbalize/build_method_base'

describe Verbalize::BuildMethodBase do
  describe '.call' do
    let(:test_class) do
      Class.new(described_class)
    end

    it 'raises NotImplementedError when the subclass does not implement #declaration' do
      test_class = Class.new(described_class) do
        def body
          'the body'
        end
      end

      expect do
        test_class.call
      end.to raise_error NotImplementedError
    end

    it 'raises NotImplementedError when the subclass does not implement #body' do
      test_class = Class.new(described_class) do
        def declaration
          'def foo'
        end
      end

      expect do
        test_class.call
      end.to raise_error NotImplementedError
    end

    it 'joins the parts together' do
      test_class = Class.new(described_class) do
        def declaration
          'def foo'
        end

        def body
          'the body'
        end
      end

      expect(test_class.call).to eq "def foo\nthe body\nend\n"
    end
  end
end
