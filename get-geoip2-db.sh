#/bin/bash
wget -q -c https://git.io/GeoLite2-Country.mmdb -P /etc/nginx/geoip
wget -q -c https://git.io/GeoLite2-City.mmdb -P /etc/nginx/geoip