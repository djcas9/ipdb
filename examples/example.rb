#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "ipdb"
require "pp"


# ip = Ipdb::Query.new(:domain => 'snorby.org', :output => 'xml')
# 
# puts ip.address
# puts ip.country_name

@ips = ['173.45.230.150', '127.0.0.1', '219.150.227.101', '219.159.199.34', '222.134.69.181', '222.188.10.1', '68.82.102.9', '80.108.206.239',
        '85.113.252.214', '86.100.64.151', '85.132.201.196', '82.228.53.39', '80.35.156.3', '82.238.32.72', '89.77.158.227', '87.97.237.135', '69.226.246.172']

Ipdb::Query.new(:ip => @ips, :output => :xml, :timeout => 100) do |ip|
  pp "#{ip.address} (#{ip.country_name} | #{ip.region_name} | #{ip.city})"
end


# nope
# Ipdb::Query.new(:ip => '173.45.230.150', :output => :xml, :timeout => 100) do |ip|
#   pp "#{ip.address} (#{ip.country_name} | #{ip.region_name} | #{ip.city})"
# end