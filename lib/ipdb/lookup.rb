require 'nokogiri'
require 'open-uri'
require 'enumerator'

module Ipdb

  # The IPinfoDB url
  # @example http://ipinfodb.com/ip_query.php?ip=74.125.45.100&output=json
  IPDBURL = 'http://ipinfodb.com/ip_query.php?ip='

  # ip address to lookup
  attr_reader :ip

  class Lookup

    def initialize(attributes={})
      @ip = attributes[:ip]
      @output = attributes[:ip]
      @url = "http://ipinfodb.com/ip_query.php?ip=#{@ip}&output=#{@output}"
      @xml = Nokogiri::XML.parse(open(@url))
    end

  end

end
