require 'ipdb/location'
require 'nokogiri'
require 'open-uri'
require 'json/pure'
require 'enumerator'
require 'uri'

module Ipdb

  class Map
    
    def initialize(address,city,country,latitude,longitude,width,height,units,zoom,div_id,div_class)
      @address = address
      @city = city
      @country = country
      @latitude = latitude
      @longitude = longitude
      @units = (units || :px).to_sym
      @width = width || 600
      @height = height || 350
      @zoom = zoom || 10
      @div_id = div_id || 'map_canvas'
      @div_class = div_class || 'ipdb'
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
        function ipdb() {
          var latlng = new google.maps.LatLng(#{@latitude}, #{@longitude});
          var myOptions = {
            zoom: #{@zoom},
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          };
          var map = new google.maps.Map(document.getElementById("#{@div_id}"), myOptions);

          var infowindow = new google.maps.InfoWindow({
              content: 'IP Address: #{@address}<br />#{@city}, #{@country}'
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
      <body onload="ipdb()">
        <div id="#{@div_id}" class="#{@div_class}" style="width: #{@width}#{@units}; height: #{@height}#{@units}"></div>
      </body>
      </html>
      EOF
    end
    
    
  end
  
end