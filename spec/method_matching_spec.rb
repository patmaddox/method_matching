require File.dirname(__FILE__) + '/spec_helper'

describe "MethodMatching" do
  it "should handle methods that match a particular regex" do
    Class.new {
      method_matching(/^foo_(.*)$/) do |method_name, *args|
        [method_name, args].flatten
      end
    }.new.foo_bar(1, "two").should == [:foo_bar, 1, "two"]
  end
end
