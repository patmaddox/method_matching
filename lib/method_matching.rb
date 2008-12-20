module MethodMatching
  def method_matching(regex, &definition)
    method_matchers[regex] = definition
    include MethodMissingDefinition unless included_modules.include?(MethodMissingDefinition)
  end

  def method_matchers
    @method_matchers ||= { }
  end

  module MethodMissingDefinition
    def method_missing(method_name, *args, &block)
      self.class.method_matchers.each do |matcher, definition|
        if method_name.to_s =~ matcher
          return definition.call(method_name, *args)
        end
      end
      super
    end
  end
end

Module.send :include, MethodMatching
