#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "ipdb"
require "pp"





# ip = Ipdb::Query.new("snorby.org").parse
# puts "#{ip.address} (#{ip.country_name} | #{ip.region_name} | #{ip.city} | #{ip.hostname})"
# puts ip.to_graph(:width => 100, :height => 100, :units => :px)


# puts Ipdb::Query.new('snorby.org').to_xml


#
# I Would like to have the syntax of: Ipdb::Query('89.77.158.227')
#
# or even Ipdb::Query.parse('89.77.158.227')
#
ip = Ipdb::Query.new('89.77.158.227').parse
puts ip.graph(:width => 500, :units => :px, :zoom => 100).render

#puts ip
# puts ip.address
# puts ip.country_name

@ips = ['173.45.230.150', 'snorby.org', '127.0.0.1', '219.150.227.101', '219.159.199.34', '222.134.69.181', '222.188.10.1', '68.82.102.9', '80.108.206.239',
        '85.113.252.214', '86.100.64.151', '85.132.201.196', '82.228.53.39', '80.35.156.3', '82.238.32.72', '89.77.158.227', '87.97.237.135', '69.226.246.172']

# Ipdb::Query.new(@ips, :timeout => 2).each do |ip|
#   puts ip.to_s
# end