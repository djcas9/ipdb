require 'ipdb/map'
require 'resolv'

module Ipdb
  class Location
    # Location
    attr_reader :location
    
    #
    # Creates a new Location object.
    #
    # @param [Nokogiri::XML::Node] node
    #   The XML node that contains the location information.
    #
    # @yield [location]
    #   If a block is given, it will be passed the newly created Location
    #   object.
    #
    # @param [String] timeout
    #   The timeout for the location object.
    #
    def initialize(location, timeout=10)
      @xml = location
      @timeout = timeout
    end

    #
    # Return the Location address.
    #
    # @return [String] address
    #
    def address
      @address = @xml.at('Ip').inner_text
    end

    #
    # Return the Location status.
    #
    # @return [String] status
    #
    def status
      @status = @xml.at('Status').inner_text
    end

    #
    # Return the Location hostname.
    #
    # @return [String] hostname
    #
    def hostname
      Timeout::timeout(@timeout) do
        @hostname = Resolv.getname(address)
      end
    rescue Timeout::Error
    rescue
    end

    #
    # Return the Location Country Coce.
    #
    # @return [String] country_code
    #
    def country_code
      @country_code = @xml.at('CountryCode').inner_text
    end

    #
    # Return the Location Country.
    #
    # @return [String] country
    #
    def country
      @country_name = @xml.at('CountryName').inner_text
    end

    #
    # Return the Location Region Code.
    #
    # @return [String] region_code
    #
    def region_code
      @region_code = @xml.at('RegionCode').inner_text
    end

    #
    # Return the Location Region.
    #
    # @return [String] region
    #
    def region
      @region_name = @xml.at('RegionName').inner_text
    end

    #
    # Return the Location City.
    #
    # @return [String] city
    #
    def city
      @city = @xml.at('City').inner_text
    end
    
    #
    # Return the Location Zip Code.
    #
    # @return [Integer] zip_code
    #
    # @see Location#zipcode
    #
    def zip_code
      @zip_code = @xml.at('ZipPostalCode').inner_text.to_i
    end
    alias zipcode zip_code

    #
    # Return the Location Latitude.
    #
    # @return [Float] latitude
    #
    def latitude
      @latitude = @xml.at('Latitude').inner_text.to_f
    end
    
    #
    # Return the Location Longitude.
    #
    # @return [Float] longitude
    #
    def longitude
      @longitude = @xml.at('Longitude').inner_text.to_f
    end

    #
    # Return the Location Time Zone Offset.
    #
    # @return [Integer] time_zone
    #
    # @see http://www.geonames.org/
    # @see Location#timezone
    #
    def time_zone
      @timezone = @xml.at('Timezone').inner_text.to_i
    end
    alias timezone time_zone

    #
    # Return the Location GMT Offset. 
    # The gmtOffset/dstOffset fields names are a little misleading => gmtOffset: offset to GMT at 1st January.
    #
    # @return [Integer] gmt_offset
    #
    # @see http://www.geonames.org/
    #
    def gmt_offset
      @gmt_offset = @xml.at('Gmtoffset').inner_text.to_i
    end

    #
    # Return the Location DST Offset. 
    # The gmtOffset/dstOffset fields names are a little misleading => dstOffset: offset to GMT at 1st July.
    #
    # @return [Integer] dst_offset
    #
    # @see http://www.geonames.org/
    #
    def dst_offset
      @dst_offset = @xml.at('Dstoffset').inner_text.to_i
    end

    #
    # Return the Location Current Time.
    #
    # @return [DateTime] current_time
    #
    # @todo Make this method work correctly! =]
    #
    def current_time
      (Time.now + timezone)
    end
    
    #
    # Return the Location as a string
    #
    # @return [String] location
    #
    def to_s
      "#{address} #{hostname} #{country} #{region} #{city}"
    end

  end
end
