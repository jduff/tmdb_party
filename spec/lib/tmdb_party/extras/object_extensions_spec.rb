require 'spec_helper'

describe 'Object extensions' do

  it "should provide the blank? method" do
    "".respond_to?(:blank?).should == true
  end

  it "should return correctly when blank? called" do
    "a".blank?.should == false
    "".blank?.should == true
  end
end