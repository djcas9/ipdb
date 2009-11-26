require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'json/pure'
require 'enumerator'
require 'uri'

module Ipdb

  class Map
    
    def initialize(options={})
      @address = options[:address]
      @latitude = options[:latitude]
      @longitude = options[:longitude]      
      @units = (options[:units] || :px).to_sym
      @width = options[:width] || 600
      @height = options[:height] || 350
      @zoom = options[:zoom] || 10
    end
    
    def marker
    end
    
    def window
    end
    
    def render
      return html = <<-EOF
      <html>
      <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
      <script type="text/javascript">
        function initialize() {
          var latlng = new google.maps.LatLng(#{@latitude}, #{@longitude});
          var myOptions = {
            zoom: #{@zoom},
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          };
          var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

          var infowindow = new google.maps.InfoWindow({
              content: 'IP: #{@address}'
          });

          var marker = new google.maps.Marker({
              position: latlng, 
              map: map,
              title: "#{@address}"
          });
          google.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map,marker);
          });
        }

      </script>
      <body onload="initialize()">
        <div id="map_canvas" style="width: #{@width}#{@units}; height: #{@height}#{@units}"></div>
      </body>
      </html>
      EOF
    end
    
    
  end
  
end