require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb
  
  #
  # The IPinfoDB url
  #
  # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
  #
  SCRIPT = 'http://ipinfodb.com/ip_query2.php'

  class Query
    include Enumerable

    #
    # Creates a new Query object.
    #
    # @param [Array] addresses/domians
    #   An array of addresses or domains.
    #
    # @param [Hash<Options>]
    #   Options for the new Query Object.
    #
    # @option opts [Integer] :timeout The Timeout. (Default: 10)
    #
    def initialize(addr=nil, options={})
      @timeout = options[:timeout]

      ip = [addr].flatten
      @url = "#{SCRIPT}?ip=#{URI.escape(ip.join(','))}"
      @xml = Nokogiri::XML.parse(open(@url))
    end

    #
    # Process The Query Object And Return A Location Object
    #
    # @return [Location]
    #   The Location object returned from the Query.
    #
    def parse
      Location.new(@xml.xpath('//Location'), @timeout)
    end

    #
    # Parses the Locations from the Query.
    #
    # @yield [Query]
    #   Each query will be passed to a given block.
    #
    # @yieldparam [Location] location
    #   A location from the query.
    #
    # @return [XML]
    #   The XML object.
    #
    def each(&block)
      @xml.xpath('//Location').each do |location|
        block.call(Location.new(location, @timeout)) if block
      end
    end

    #
    # Return the url of the Query
    #
    # @return [String] url
    #
    def url
      @url
    end

    #
    # Return the Query object in json format.
    #
    # @return [Query] json
    #
    def to_json
      json = "#{@url}&output=json"
      @doc = Nokogiri::HTML(open(json))
      return @doc.xpath('//body/.').inner_text
    end

    #
    # Return the Query in XML format.
    #
    # @return [Query] xml
    #
    def to_s
      @xml
    end

    alias to_xml to_s
    alias all to_a
    
    #
    # Return a map url of addresses from the Query
    #
    # @return [String] url
    #
    def simple_map_url
      @country_codes = []
      @colors = []
      Enumerator.new(self,:each).to_a.collect {|x| @country_codes << x.country_code }
      @country_codes = @country_codes.uniq
      1.upto(@country_codes.size) { |x| @colors << '0' }
      url = "http://chart.apis.google.com/chart?cht=t&chs=440x220&chd=t:#{@colors.join(',')}&chco=FFFFFF,4A4A4A,EBEBEB&chld=#{@country_codes}&chtm=world&chf=bg,s,EAF7FE"
      return url
    end
    
    #
    # Convenient Method to render the map url as an image in Rails.
    #
    # @return [String] image
    #
    def simple_map_image
      "image_path(#{simple_map_url})"
    end

  end
end
