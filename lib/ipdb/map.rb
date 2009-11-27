require 'ipdb/location'
module Ipdb

  class Map

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
    
    def build_options(start)
      "var myOptions = {zoom: #{@zoom},center: #{start},mapTypeId: google.maps.MapTypeId.ROADMAP};var map = new google.maps.Map(document.getElementById('#{@div_id}'), myOptions);"
    end

    def new_location(latitude,longitude)
      "new google.maps.LatLng(#{latitude}, #{longitude})"
    end

    def add_marker(id,address,latitude,longitude)
      "var marker_#{id} = new google.maps.Marker({position: new google.maps.LatLng(#{latitude}, #{longitude}), map: map, title: '#{address}'});"
    end

    def add_window(id, address, city, country)
      "var infowindow_#{id} = new google.maps.InfoWindow({content: 'IP Address: #{address}<br />#{city}, #{country}'});"
    end

    def add_listener(id)
      "google.maps.event.addListener(marker_#{id}, 'click', function() {infowindow_#{id}.open(map,marker_#{id});});"
    end

    def build_map(start, data)
      return <<-EOF
<script type="text/javascript" src="http://www.google.com/jsapi?autoload=%7Bmodules%3A%5B%7Bname%3A%22maps%22%2Cversion%3A3%2Cother_params%3A%22sensor%3Dfalse%22%7D%5D%7D"></script>
<script type="text/javascript">function ipdb() {#{build_options(start)}#{data}};google.setOnLoadCallback(ipdb);</script>
<div id="#{@div_id}" class="#{@div_class}" style="width: #{@width}#{@units}; height: #{@height}#{@units}"></div>
      EOF
    end

  end
  
end