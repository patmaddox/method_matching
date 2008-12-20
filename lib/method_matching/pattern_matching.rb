module Kernel
  def pattern_match(name, *patterns, &definition)
    pattern_matchers << Pattern.new(patterns, definition)
    mdef = <<-END
      def #{name}(*args)
        self.class.pattern_matchers.each do |p|
          return p.execute if p =~ args
        end
    
        arg_inspect = args.map { |a| a.inspect }.join(', ')
        raise "No pattern matching #\{arg_inspect\}"
      end
    END
    class_eval mdef
  end  

  def pattern_matchers
    @pattern_matchers ||= []
  end

  class Pattern
    def initialize(patterns, definition)
      @patterns = patterns
      @definition = definition
    end

    def =~(args)
      @patterns.each_with_index do |p, i|
        return false unless p === args[i]
      end
      true
    end

    def execute
      @definition.call
    end
  end
end
