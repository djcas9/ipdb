require 'ipdb/location'
module Ipdb

  class Map

    #
    # Creates a new Map object.
    #
    # @param [Array] addresses/domians
    #   An array of addresses or domains.
    #
    # @param [Hash] options The options to create a Map with.
    #
    # @option options [Integer] :timeout ('10') The Timeout.
    # @option options [Symbol] :units (':px') The units for width and height.
    # @option options [Integer] :width ('600') The width of the Map.
    # @option options [Integer] :height ('350') The height of the Map.
    # @option options [Integer] :zoom ('10') The zoom of the Map.
    # @option options [String] :div_id ('map_canvas') The div id of the Map container.
    # @option options [String] :div_class ('ipdb') The div class of the Map container.
    #
    # @return [MAP] map The newly created Map Object.
    #
    # @example
    #   Ipdb::Map.new(@ips, :zoom => 1, :width => 100, :height => 100, :units => :%)
    def initialize(addr=nil, options={})
      @timeout = options[:timeout] || 10
      @units = (options[:units] || :px).to_sym
      @width = options[:width] || 600
      @height = options[:height] || 350
      @zoom = options[:zoom] || 10
      @div_id = options[:div_id] || 'map_canvas'
      @div_class = options[:div_class] || 'ipdb'

      ip = [addr].flatten
      @url = "#{SCRIPT}?ip=#{URI.escape(ip.join(','))}"
      @xml = Nokogiri::XML.parse(open(@url)).xpath('//Location')
    end
    
    #
    # Return a Google Map for a Query Object
    #
    # @return [String<HTML, JavaScript>] map The Google Map html and JavaScript.
    #
    def render
      @map = ""; @id = 0
      @xml.each do |x|
        location = Location.new(x, @timeout)
        id = "ip_#{@id += 1}_id"
        @start = new_location(location.latitude, location.longitude) if @id == 1
        @map += add_marker(id, location.address, location.latitude, location.longitude)
        @map += add_window(id, location.address, location.city, location.country)
        @map += add_listener(id)
      end
      build_map(@start, @map)
    end
    
    private
    
    #
    # Build the Google maps options hash.
    #
    # @private
    #
    def build_options(start)
      "var myOptions = {zoom: #{@zoom},center: #{start},mapTypeId: google.maps.MapTypeId.ROADMAP};var map = new google.maps.Map(document.getElementById('#{@div_id}'), myOptions);"
    end

    #
    # Build a new Google Map Location object.
    #
    # @param [Float] latitude The new location objects latitude.
    # @param [Float] longitude The new location objects longitude.
    #
    # @private
    #
    def new_location(latitude,longitude)
      "new google.maps.LatLng(#{latitude}, #{longitude})"
    end

    #
    # Build a Google Map marker for the Location.
    #
    # @param [String] id The Location id.
    # @param [String] address The Location address.
    # @param [Float] latitude The new location objects latitude.
    # @param [Float] longitude The new location objects longitude.
    #
    # @private
    #
    def add_marker(id,address,latitude,longitude)
      "var marker_#{id} = new google.maps.Marker({position: new google.maps.LatLng(#{latitude}, #{longitude}), map: map, title: '#{address}'});"
    end
    
    #
    # Build a Google Map Window for the Location.
    #
    # @param [String] id The Location id.
    # @param [String] address The Location address.
    # @param [String] city The location city.
    # @param [String] country The location country.
    #
    # @private
    #
    def add_window(id, address, city, country)
      "var infowindow_#{id} = new google.maps.InfoWindow({content: 'IP Address: #{address}<br />#{city}, #{country}'});"
    end

    #
    # Build a Google map Listener to watch for marker clicks.
    #
    # @param [String] id The Location id.
    #
    def add_listener(id)
      "google.maps.event.addListener(marker_#{id}, 'click', function() {infowindow_#{id}.open(map,marker_#{id});});"
    end

    #
    # Build The Google Map.
    #
    # @param [String] start A Google Map Location object to use as a starting point.
    # @param [String] data The Google Map js built from the Location object.
    #
    # @private
    #
    def build_map(start, data)
      return <<-EOF
<script type="text/javascript" src="http://www.google.com/jsapi?autoload=%7Bmodules%3A%5B%7Bname%3A%22maps%22%2Cversion%3A3%2Cother_params%3A%22sensor%3Dfalse%22%7D%5D%7D"></script>
<script type="text/javascript">function ipdb() {#{build_options(start)}#{data}};google.setOnLoadCallback(ipdb);</script>
<div id="#{@div_id}" class="#{@div_class}" style="width: #{@width}#{@units}; height: #{@height}#{@units}"></div>
      EOF
    end

  end
  
end