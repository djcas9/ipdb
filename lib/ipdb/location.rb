require 'ipdb/map'
require 'resolv'

module Ipdb
  class Location

    attr_reader :location

    def initialize(location, timeout=10)
      @xml = location
      @timeout = timeout
    end

    def address
      @address = @xml.at('Ip').inner_text
    end

    def hostname
      Timeout::timeout(@timeout) do
        @hostname = Resolv.getname(address)
      end
    rescue Timeout::Error
    rescue
    end

    def country_code
      @country_code = @xml.at('CountryCode').inner_text
    end

    def country
      @country_name = @xml.at('CountryName').inner_text
    end

    def region_code
      @region_code = @xml.at('RegionCode').inner_text
    end

    def region
      @region_name = @xml.at('RegionName').inner_text
    end

    def city
      @city = @xml.at('City').inner_text
    end

    def zip_code
      @zip_code = @xml.at('ZipPostalCode').inner_text
    end
    alias zipcode zip_code

    def latitude
      @latitude = @xml.at('Latitude').inner_text.to_f
    end

    def longitude
      @longitude = @xml.at('Longitude').inner_text.to_f
    end

    def time_zone
      @timezone = @xml.at('Timezone').inner_text.to_i
    end
    alias timezone time_zone

    def gmt_offset
      @gmt_offset = @xml.at('Gmtoffset').inner_text.to_i
    end

    def dst_offset
      @dst_offset = @xml.at('Dstoffset').inner_text.to_i
    end

    def current_time
      (Time.now + timezone)
    end
    
    def to_s
      "#{address} #{hostname} #{country} #{region} #{city}"
    end

  end
end
