require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb

  class Query
    include Enumerable

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/ip_query2.php'

    def initialize(addr, options={})
      @timeout = options[:timeout] || 10

      ip = [addr].flatten
      @url = "#{SCRIPT}?ip=#{URI.escape(ip.join(','))}"
      @xml = Nokogiri::XML.parse(open(@url))
    end

    def each(&block)
      @xml.xpath('//Location').each do |location|
        block.call(Location.new(location, @timeout)) if block
      end
    end
    
    def parse
      Location.new(@xml.xpath('//Location'), @timeout)
    end

    def url
      @url
    end
    
    def to_json
      json = "#{@url}&output=json"
      @doc = Nokogiri::HTML(open(json))
      return @doc.xpath('//body/.').inner_text
    end

    def to_s
      @xml
    end

    alias to_xml to_s
    alias all to_a

  end
end
