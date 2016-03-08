class BuildMethodBase
  def initialize(arguments, keyword_arguments, method_name = nil)
    @arguments         = arguments
    @keyword_arguments = keyword_arguments
    @method_name       = method_name
  end

  def build
    parts.compact.join "\n"
  end

  private

  attr_reader :arguments, :keyword_arguments, :method_name

  def parts
    [declaration, body, 'end']
  end

  def declaration
    raise NotImplementedError
  end

  def body
    raise NotImplementedError
  end

  def variables
    arguments + keyword_arguments.keys
  end

  def declaration_keyword_arguments
    [required_keyword_arguments, defaulted_keyword_arguments].compact.join(', ')
  end

  def required_keyword_arguments
    arguments.map{ |argument| "#{argument}:" }.join(', ') unless arguments.empty?
  end

  def defaulted_keyword_arguments
    keyword_arguments.map{ |keyword, value| "#{keyword}: #{value.inspect}" }.join(', ') unless keyword_arguments.empty?
  end
end
