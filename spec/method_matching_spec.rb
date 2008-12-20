require File.dirname(__FILE__) + '/spec_helper'

describe "MethodMatching" do
  it "should handle methods that match a particular regex" do
    Class.new {
      method_matching(/^foo_(.*)$/) do |method_name, *args|
        [method_name, args].flatten
      end
    }.new.foo_bar(1, "two").should == [:foo_bar, 1, "two"]
  end

  it "should handle two method matchers" do
    klass = Class.new do
      method_matching(/^foo_(.*)$/) do |method_name, *args|
        [method_name, args].flatten
      end

      method_matching(/^baz_(.*)$/) { |mn, *args| mn }
    end

    klass.new.foo_bar(1, "two").should == [:foo_bar, 1, "two"]
    klass.new.baz_chicken.should == :baz_chicken
  end

  it "should not screw with an existing method_missing" do
    klass = Class.new do
      def method_missing(method_name, *args, &block)
        return :caught if method_name == :from_mm
        super
      end

      method_matching(/^foo_(.*)$/) { |mn, *args| mn }
    end

    klass.new.from_mm.should == :caught
    klass.new.foo_bar.should == :foo_bar
  end

  it "should not be clobbered by a new method_missing" do
    klass = Class.new do
      method_matching(/^foo_(.*)$/) { |mn, *args| mn }

      def method_missing(method_name, *args, &block)
        return :caught if method_name == :from_mm
        super
      end
    end

    klass.new.from_mm.should == :caught
    klass.new.foo_bar.should == :foo_bar
  end
end
