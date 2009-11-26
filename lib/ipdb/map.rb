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
    
    def options
      "var myOptions = {zoom: #{@zoom},center: p1,mapTypeId: google.maps.MapTypeId.ROADMAP};
      var map = new google.maps.Map(document.getElementById('#{@div_id}'), myOptions);"
    end
    
    def position
      "var p1 = new google.maps.LatLng(#{@latitude}, #{@longitude});"
    end
    
    def marker
      "var marker = new google.maps.Marker({position: p1, map: map, title: '#{@address}'});"
    end
    
    def window
      "var infowindow = new google.maps.InfoWindow({content: 'IP Address: #{@address}<br />#{@city}, #{@country}'});"
    end
    
    def add_window
      "google.maps.event.addListener(marker, 'click', function() {infowindow.open(map,marker);});"
    end
    
    def render
      return <<-EOF
      <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
      <script type="text/javascript">
      jQuery(document).ready(function($) {ipdb();function ipdb() {#{position}#{options}#{window}#{marker}#{add_window}}});
      </script>
      <div id="#{@div_id}" class="#{@div_class}" style="width: #{@width}#{@units}; height: #{@height}#{@units}"></div>
      EOF
    end
    
    
  end
  
end