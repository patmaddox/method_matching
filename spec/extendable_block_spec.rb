require File.dirname(__FILE__) + '/spec_helper'

module MethodMatching
  describe ExtendableBlock do
    it "should give a friendly message when block is called but none is set" do
      ExtendableBlock.new { block.call }.
        should raise_error(/No block given/)
    end
  end
end
