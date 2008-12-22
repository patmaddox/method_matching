class Object
  def method_matching(regex, &definition)
    # TODO: wtf this is oogly, but I don't know how
    # to get around it
    if self.class == Module
      method_matchers[regex] = definition
    else
      method_matchers[regex] = MethodMatching::ExtendableBlock.new &definition
      klass = private_methods.include?("include") ? self : (class << self; self; end)
      klass.class_eval do
        include MethodMissingDefinition unless included_modules.include?(MethodMissingDefinition)
      end
    end
  end

  def method_matchers
    @method_matchers ||= { }
  end

  module MethodMissingDefinition
    def method_missing(method_name, *args, &block)
      try_matcher = Proc.new do |matcher, mdef|
        if method_name.to_s =~ matcher
          mdef.block = block
          return mdef.call(method_name, *args)
        end
      end

      method_matchers.each { |m, mdef| try_matcher.call(m, mdef) }
      self.class.method_matchers.each { |m, mdef| try_matcher.call(m, mdef) }
      super
    end

    def respond_to?(method_name)
      (method_matchers.keys +
       self.class.method_matchers.keys).each do |matcher|
        return true if method_name.to_s =~ matcher
      end
      super
    end
  end
end
