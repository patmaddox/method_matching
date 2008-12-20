module Kernel
  def pattern_match(name, *patterns, &definition)
    pattern_matchers << MethodMatching::PatternMatcher.new(patterns, definition)

    mdef = <<-END
      def #{name}(*args, &block)
        self.class.pattern_matchers.each do |p|
          if p =~ args
            p.definition.block = block
            return p.definition.call(*args) 
          end
        end
    
        arg_inspect = if args.empty?
          '(no args given)'
        else
          args.map { |a| a.inspect }.join(', ')
        end
        raise "No pattern matching #\{arg_inspect\}"
      end
    END
    class_eval mdef
  end  

  def pattern_matchers
    @pattern_matchers ||= []
  end
end

module MethodMatching
  class PatternMatcher
    attr_reader :definition

    def initialize(patterns, definition)
      @patterns = patterns
      @definition = ExtendableBlock.new(&definition)
    end

    def =~(args)
      return false if args.size != @patterns.size
      @patterns.each_with_index do |p, i|
        return false unless p === args[i]
      end
      true
    end
  end
end
