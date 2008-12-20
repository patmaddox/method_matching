$:.unshift File.dirname(__FILE__)
require 'ext/instance_exec'
require 'method_matching/extendable_block'

module MethodMatching
  def method_matching(regex, &definition)
    method_matchers[regex] = ExtendableBlock.new &definition
    include MethodMissingDefinition unless included_modules.include?(MethodMissingDefinition)
  end

  def method_matchers
    @method_matchers ||= { }
  end

  module MethodMissingDefinition
    def method_missing(method_name, *args, &block)
      self.class.method_matchers.each do |matcher, mdef|
        if method_name.to_s =~ matcher
          mdef.block = block
          return mdef.call(method_name, *args)
        end
      end
      super
    end
  end
end

Module.send :include, MethodMatching
