require File.dirname(__FILE__) + '/spec_helper'

describe "pattern_match" do
  def o(&block)
    Class.new(&block).new
  end

  it "should call the method when pattern is matched" do
    o { pattern_match(:foo, Integer) { :integer } }.
      foo(123).should == :integer
  end
  
  it "should raise an error when the pattern doesn't match" do
    lambda { o { pattern_match(:foo, Integer) { :integer } }.
      foo("uh", "oh") }.
      should raise_error(/No pattern matching "uh", "oh"/)
  end
end
