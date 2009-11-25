$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "ipdb"
require "pp"


ip = Ipdb::Lookup.new(:ip => '173.45.230.150', :output => 'xml')

pp ip
