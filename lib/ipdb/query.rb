require 'nokogiri'
require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb
  class Query

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/ip_query.php'

    # IP address to lookup
    attr_reader :address

    def initialize(ips=[], attributes={}, &block)
      @address = attributes[:ip]
      @output = (attributes[:output] || :xml).to_sym

      if ips
        
        @url = "#{SCRIPT}?ip=#{URI.escape(attributes[:ip])}&output=#{@output}"
        @xml = Nokogiri::XML.parse(open(@url))
        block.call(self) if block
      
      else
        
        ips.each do |ip|
          @url = "#{SCRIPT}?ip=#{URI.escape(ip)}&output=#{@output}"
          @xml = Nokogiri::XML.parse(open(@url))
          block.call(self) if block
        end
        
      end

    end
    
    def address
      @address = @xml.at('/Response/Ip').inner_text
    end
    
    def country_code
      @country_code = @xml.at('/Response/CountryCode').inner_text
    end

    def country_name
      @country_name = @xml.at('/Response/CountryName').inner_text
    end

    def region_code
      @region_code = @xml.at('/Response/RegionCode').inner_text
    end

    def region_name
      @region_name = @xml.at('/Response/RegionName').inner_text
    end

    def city
      @city = @xml.at('/Response/City').inner_text
    end

    def zip_code
      @zip_code = @xml.at('/Response/ZipPostalCode').inner_text
    end

    def latitude
      @latitude = @xml.at('/Response/Latitude').inner_text.to_f
    end

    def longitude
      @longitude = @xml.at('/Response/ZipPostalCode').inner_text.to_f
    end

    def timezone
      @timezone = @xml.at('/Response/Timezone').inner_text.to_i
    end

    def gmt_offset
      @gmt_offset = @xml.at('/Response/Gmtoffset').inner_text.to_i
    end

    def dst_offset
      @dst_offset = @xml.at('/Response/Dstoffset').inner_text.to_i
    end

  end
end
