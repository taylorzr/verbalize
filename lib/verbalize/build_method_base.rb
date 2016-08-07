class BuildMethodBase
  def initialize(keywords, method_name = :call)
    @keywords    = keywords
    @method_name = method_name
  end

  def build
    parts.compact.join "\n"
  end

  private

  attr_reader :keywords, :method_name

  def parts
    [declaration, body, 'end']
  end

  def declaration
    raise NotImplementedError
  end

  def body
    raise NotImplementedError
  end

  def declaration_keyword_arguments
    return if keywords.empty?
    keywords.map { |keyword| "#{keyword}: nil" }.join(', ')
  end
end
