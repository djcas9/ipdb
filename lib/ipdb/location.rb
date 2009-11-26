require "resolv"

module Ipdb
  class Location

    attr_reader :location

    def initialize(location, timeout)
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
      @longitude = @xml.at('Longitude').inner_text.to_f
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
    
    def current_gmt_time
      Time.now + gmt_offset
    end
    
    def current_dst_time
      Time.now + dst_offset
    end

    def current_time
      (Time.now + timezone)
    end

    def to_graph(options={})
      unit = (options[:units] || :px).to_sym
      width = options[:width] || 600
      height = options[:height] || 350
      
      return html = <<-EOF
      <html>
      <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
      <script type="text/javascript">
        function initialize() {
          var latlng = new google.maps.LatLng(#{latitude}, #{longitude});
          var myOptions = {
            zoom: 10,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          };
          var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

          var infowindow = new google.maps.InfoWindow({
              content: 'IP: #{address}'
          });

          var marker = new google.maps.Marker({
              position: latlng, 
              map: map,
              title: "#{address}"
          });
          google.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map,marker);
          });
        }

      </script>
      <body onload="initialize()">
        <div id="map_canvas" style="width: #{width}#{unit}; height: #{height}#{unit}"></div>
      </body>
      </html>
      EOF
    end
    
    def to_s
      "#{address} #{hostname} #{country_code} #{country_name} #{region_name} #{city} #{zip_code}"
    end

  end
end
