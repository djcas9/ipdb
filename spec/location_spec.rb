require 'spec_helper'

describe "Location" do

  before(:all) do
    @ip = Ipdb::Query.new('64.13.134.52').parse
  end

  it "should return the Location hostname" do
    @ip.hostname.should == 'scanme.nmap.org'
  end
  
  it "should return the Location ip address" do
    @ip.address.should == '64.13.134.52'
  end
  
  it "should return the Location Country" do
    @ip.country.should == 'United States'
  end
  
  it "should return the Location Region" do
    @ip.region.should == 'California'
  end

  it "should return the Location City" do
    @ip.city.should == 'Sunnyvale'
  end
  
  it "should return the Location Status" do
    @ip.status.should == 'OK'
  end

end
