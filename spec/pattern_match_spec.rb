require File.dirname(__FILE__) + '/spec_helper'

describe "pattern_match" do
  def o(&block)
    Class.new(&block).new
  end

  def not_pattern_match
    raise_error(/No pattern matching/)
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

  it "should handle multiple patterns" do
    o { pattern_match(:foo, Numeric, /asdf/) { :matched } }.
      foo(123, "FOOasdfBAR").should == :matched
  end

  it "should raise a nice error when not matched & no args given" do
    lambda { o { pattern_match(:foo, Integer) { :integer } }.
      foo }.
      should not_pattern_match
  end

  it "should match no args" do
    object = o { pattern_match(:foo) { :matched } }
    object.foo.should == :matched
    lambda { object.foo(123) }.should not_pattern_match
  end

  it "should match literals" do
    object = o { pattern_match(:foo, "asdf") { :matched } }
    object.foo("asdf").should == :matched
    lambda { object.foo("asdfbar") }.should not_pattern_match
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
