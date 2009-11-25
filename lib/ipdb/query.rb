require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb
  class Query

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/'

    def initialize(options={}, &block)
      @output = (options[:output] || :xml).to_sym
      @timeout = options[:timeout] || 100

      if options[:ip]
        @url = "#{SCRIPT}ip_query2.php?ip=#{URI.escape(options[:ip].join(','))}&output=#{@output}"
      elsif options[:domain]
        # ...
      else
        raise(RuntimeError,"must specify either the :ip or :domain option",caller)
      end


      @xml = Nokogiri::XML.parse(open(@url))

      @xml.xpath('//Location').each do |location|
        block.call(Location.new(location)) if block
      end

    end

  end
end
