require 'spec_helper'
 
describe 'Ipdb' do
  it "should have a SCRIPT constant" do
    Ipdb.const_defined?('SCRIPT').should == true
  end
end
