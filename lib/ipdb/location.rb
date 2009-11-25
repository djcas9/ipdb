require "resolv"

module Ipdb
  class Location

    attr_reader :location

    def initialize(location)
      @xml = location
    end

    def address
      @address = @xml.at('Ip').inner_text
    end

    def hostname
      @hostname = Resolv.getname(address)
    rescue

    end

    def country_code
      @country_code = @xml.at('CountryCode').inner_text
    end

    def country_name
      @country_name = @xml.at('CountryName').inner_text
    end

    def region_code
      @region_code = @xml.at('RegionCode').inner_text
    end

    def region_name
      @region_name = @xml.at('RegionName').inner_text
    end

    def city
      @city = @xml.at('City').inner_text
    end

    def zip_code
      @zip_code = @xml.at('ZipPostalCode').inner_text
    end

    def latitude
      @latitude = @xml.at('Latitude').inner_text.to_f
    end

    def longitude
      @longitude = @xml.at('ZipPostalCode').inner_text.to_f
    end

    def timezone
      @timezone = @xml.at('Timezone').inner_text.to_i
    end

    def gmt_offset
      @gmt_offset = @xml.at('Gmtoffset').inner_text.to_i
    end

    def dst_offset
      @dst_offset = @xml.at('Dstoffset').inner_text.to_i
    end

  end
end
