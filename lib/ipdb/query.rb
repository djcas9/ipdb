require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb

  # The IPinfoDB url
  # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
  SCRIPT = 'http://ipinfodb.com/ip_query2.php'

  class Query
    include Enumerable

    def initialize(addr=nil, options={})
      @timeout = options[:timeout]

      ip = [addr].flatten
      @url = "#{SCRIPT}?ip=#{URI.escape(ip.join(','))}"
      @xml = Nokogiri::XML.parse(open(@url))
    end

    def parse
      Location.new(@xml.xpath('//Location'), @timeout)
    end

    def each(&block)
      @xml.xpath('//Location').each do |location|
        block.call(Location.new(location, @timeout)) if block
      end
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
    
    def simple_map_url
      @country_codes = []
      @colors = []
      Enumerator.new(self,:each).to_a.collect {|x| @country_codes << x.country_code }
      @country_codes = @country_codes.uniq
      1.upto(@country_codes.size) { |x| @colors << '0' }
      url = "http://chart.apis.google.com/chart?cht=t&chs=440x220&chd=t:#{@colors.join(',')}&chco=FFFFFF,4A4A4A,EBEBEB&chld=#{@country_codes}&chtm=world&chf=bg,s,EAF7FE"
      return url
    end
    
    def simple_map_image
      "image_path(#{simple_map_url})"
    end

  end
end
