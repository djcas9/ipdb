require 'open-uri'
require 'enumerator'
require 'uri'

module Ipdb
  class Query

    # The IPinfoDB url
    # @example http://ipinfodb.com/ip_query.php?ip=127.0.0.1&output=json
    SCRIPT = 'http://ipinfodb.com/ip_query.php'

    # ip address to lookup
    attr_reader :ip

    # output format
    attr_reader :output

    # URL of the query
    attr_reader :url

    def initialize(attributes={})
      @ip = attributes[:ip]
      @output = (attributes[:output] || :xml).to_sym
      @url = "#{SCRIPT}?ip=#{URI.escape(@ip)}&output=#{@output}"

      case @output
      when :xml
        require 'nokogiri'

        @xml = Nokogiri::XML.parse(open(@url))
      end
    end

  end
end
