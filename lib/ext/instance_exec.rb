class Object
  unless defined? instance_exec # 1.9
    def instance_exec(*arguments, &block)
      block.bind(self)[*arguments]
    end
  end
end

class Proc
  unless defined? bind
    def bind(object)
      block, time = self, Time.now
      (class << object; self end).class_eval do
        method_name = "__bind_#{time.to_i}_#{time.usec}"
        define_method(method_name, &block)
        method = instance_method(method_name)
        remove_method(method_name)
        method
      end.bind(object)
    end
  end
end
