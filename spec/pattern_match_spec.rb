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

  it "should raise a nice error when not matched & no args given" do
    lambda { o { pattern_match(:foo, Integer) { :integer } }.
      foo }.
      should raise_error(/No pattern matching \(no args given\)/)    
  end
  
  it "should match literals" do
    o { pattern_match(:foo, "asdf") { :matched } }.
      foo("asdf").should == :matched
  end

  it "should match superclasses" do
    o { pattern_match(:foo, Numeric) { :matched} }.
      foo(123.45).should == :matched
  end

  it "should handle blocks" do
    o { pattern_match(:foo, Integer) { block.call } }.
      foo(123) { :hello! }.should == :hello!
  end

  it "should know about block_given?" do
    object = o { pattern_match(:foo, Integer) { block_given? } }
    object.foo(123).should be_false
    object.foo(123) { :hello }.should be_true
  end
end
