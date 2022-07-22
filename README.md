
# NGINX open source with geoip2 module support

Add the following in your nginx configuration either in http context or stream context. 
Then use $geoip_country_code & $geoip_city_code as variables.

```
geoip2 /etc/nginx/geoip/GeoLite2-Country.mmdb {
   $geoip_country_code default=UnknownCountry source=$remote_addr country iso_code;
}

geoip2 /etc/nginx/geoip/GeoLite2-City.mmdb {
   $geoip_city_code default=UnknownCity city names en;
}

```
# License
Database & Contents Copyright (C) **[Maxmind](https://www.maxmind.com/en/geoip2-services-and-databases)**, Inc. 
