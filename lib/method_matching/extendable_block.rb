module MethodMatching
  class ExtendableBlock
    attr_accessor :block
    
    def initialize(&definition)
      @definition = definition
    end
    
    def call(*args)
      instance_exec(*args, &@definition)
    end

    def block_given?
      !!@block
    end
  end
end