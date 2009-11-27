require 'rubygems'
require 'rake'

require './tasks/spec.rb'
require './tasks/yard.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "IpDB"
    gem.summary = "IpDB is a simple IP geographical locator."
    gem.description = "IpDB is a ruby interface to the ipinfodb IP geographical locator api."
    gem.email = "dustin.webber@gmail.com"
    gem.homepage = "http://github.com/mephux/ipdb"
    gem.authors = ["Dustin Willis Webber"]
    gem.add_dependency "nokogiri", ">= 1.4.0"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">=0.2.3.5"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

# vim: syntax=ruby
