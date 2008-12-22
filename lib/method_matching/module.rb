class Module
  def included_with_method_matching(target)
    result = included_without_method_matching target
    method_matchers.each do |regex, definition|
      target.method_matching regex, &definition
    end
    result
  end
  alias_method :included_without_method_matching, :included
  alias_method :included, :included_with_method_matching
end
