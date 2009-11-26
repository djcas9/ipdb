require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'json/pure'
require 'enumerator'
require 'uri'

module Ipdb

  class Query
    include Enumerable

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/ip_query2.php'

    def initialize(addr, options={})
      @output = (options[:output] || :xml).to_sym
      @timeout = options[:timeout] || 10

      ip = [addr].flatten
      @url = "#{SCRIPT}?ip=#{URI.escape(ip.join(','))}&output=#{@output}"
      case @output
        when :xml
          @xml = Nokogiri::XML.parse(open(@url))
        when :json
          buffer = open(@url).read
          blah = JSON.parse(buffer)
          return blah
      end
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
    
    def to_xml
      @xml
    end
    
    def to_json
      @xml
    end
    
    def to_s
      @xml.to_s
    end

  end
end
