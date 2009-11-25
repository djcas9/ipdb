require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb
  class Query

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/ip_query.php'

    # IP address to lookup
    attr_reader :ip

    # output format
    attr_reader :output

    # URL of the query
    attr_reader :url

    # Status of the query
    attr_reader :status

    # Country Code of the IP
    attr_reader :country_code

    # Country Name of the IP
    attr_reader :country_name

    # Region Code of the IP
    attr_reader :region_code

    # Region Name of the IP
    attr_reader :region_name

    # City of the IP
    attr_reader :city

    # Zip Code of the IP
    attr_reader :zip_code

    # Latitude of the IP
    attr_reader :latitude

    # Longitude of the IP
    attr_reader :longitude

    # Timezone of the IP
    attr_reader :timezone

    # GMT offset of the IP
    attr_reader :gmt_offset

    # DST offset of the IP
    attr_reader :dst_offset

    def initialize(attributes={})
      @ip = attributes[:ip]
      @output = (attributes[:output] || :xml).to_sym
      @url = "#{SCRIPT}?ip=#{URI.escape(@ip)}&output=#{@output}"

      case @output
      when :xml
        require 'nokogiri'

        xml = Nokogiri::XML.parse(open(@url))

        @status = if xml.at('/Response/Status/.') == 'OK'
                    :ok
                  else
                    :not_found
                  end

        @country_code = xml.at('/Response/CountryCode').inner_text
        @country_name = xml.at('/Response/CountryName').inner_text

        @region_code = xml.at('/Response/RegionCode').inner_text
        @region_name = xml.at('/Response/RegionName').inner_text

        @city = xml.at('/Response/City').inner_text
        @zip_code = xml.at('/Response/ZipPostalCode').inner_text

        @latitude = xml.at('/Response/Latitude').inner_text.to_f
        @longitude = xml.at('/Response/ZipPostalCode').inner_text.to_f

        @timezone = xml.at('/Response/Timezone').inner_text.to_i
        @gmt_offset = xml.at('/Response/Gmtoffset').inner_text.to_i
        @dst_offset = xml.at('/Response/Dstoffset').inner_text.to_i
      end
    end

  end
end
