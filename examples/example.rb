$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "ipdb"
require "pp"


ip = Ipdb::Lookup.new(:ip => '127.0.0.1')

pp ip
