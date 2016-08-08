class BuildMethodBase
  def initialize(required_keywords: [], optional_keywords: [], method_name: :call)
    @required_keywords = required_keywords
    @optional_keywords = optional_keywords
    @method_name       = method_name
  end

  def build
    parts.compact.join "\n"
  end

  private

  attr_reader :required_keywords, :optional_keywords, :method_name

  def parts
    [declaration, body, 'end']
  end

  def declaration
    raise NotImplementedError
  end

  def body
    raise NotImplementedError
  end

  def all_keywords
    required_keywords + optional_keywords
  end

  def declaration_keyword_arguments
    return if all_keywords.empty?
    required_keywords_segments = required_keywords.map { |keyword| "#{keyword}:" }
    optional_keyword_segments  = optional_keywords.map { |keyword| "#{keyword}: nil" }
    (required_keywords_segments + optional_keyword_segments).join(', ')
  end
end
