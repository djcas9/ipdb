#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "ipdb"
require "pp"


# ip = Ipdb::Query.new(:ip => '173.45.230.150', :output => 'xml')
# 
# puts ip.address

@ips = ['173.45.230.150', '127.0.0.1']

Ipdb::Query.new(:ips => @ips, :output => :xml) do |ip|
  puts ip.address
  puts ip.hostname
end
