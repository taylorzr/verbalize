class BuildMethodBase
  def initialize(arguments, method_name = nil)
    @arguments   = arguments
    @method_name = method_name
  end

  def build
    parts.compact.join "\n"
  end

  private

  attr_reader :arguments, :method_name

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
    arguments
  end

  def declaration_keyword_arguments
    return if arguments.empty?
    arguments.map { |argument| "#{argument}: nil" }.join(', ')
  end
end
