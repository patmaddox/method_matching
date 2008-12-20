module MethodMatching
  class ExtendableBlock
    attr_writer :block
    
    def initialize(&definition)
      @definition = definition
    end
    
    def call(*args)
      instance_exec(*args, &@definition)
    end

    def block
      block_given?? @block : raise("No block given")
    end

    def block_given?
      !!@block
    end
  end
end
