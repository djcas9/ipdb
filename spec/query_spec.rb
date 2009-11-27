require 'spec_helper'

describe "Query" do

  before(:all) do
    @query = Ipdb::Query.new('64.13.134.52')
  end

  it "should return the Query url" do
    @query.url.should == 'http://ipinfodb.com/ip_query2.php?ip=64.13.134.52'
  end

end
