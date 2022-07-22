ARG NGINX_VERSION=1.23.1
FROM nginx:$NGINX_VERSION

ARG NGINX_VERSION=1.23.1
ARG GEOIP2_VERSION=3.4
RUN apt-get update \
    && apt-get install apt-utils && apt-get install -y \
        build-essential \
        libpcre++-dev \
        zlib1g-dev \
        libgeoip-dev \
        libmaxminddb-dev \
        wget \
        git

RUN cd /opt \
    && git clone --depth 1 -b $GEOIP2_VERSION --single-branch https://github.com/leev/ngx_http_geoip2_module.git \
    && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zxfv - \
    && mv /opt/nginx-$NGINX_VERSION /opt/nginx \
    && cd /opt/nginx \
    && ./configure --with-compat --add-dynamic-module=/opt/ngx_http_geoip2_module --with-stream \
    && make modules && ls -la /opt/nginx/objs/*.so

FROM nginx:$NGINX_VERSION

COPY --from=0 /opt/nginx/objs/ngx_http_geoip2_module.so /usr/lib/nginx/modules
COPY --from=0 /opt/nginx/objs/ngx_stream_geoip2_module.so /usr/lib/nginx/modules
COPY get-geoip2-db.sh /docker-entrypoint.d/

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests libmaxminddb0 wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod -R 644 /usr/lib/nginx/modules/ngx_http_geoip2_module.so \
    && chmod -R 644 /usr/lib/nginx/modules/ngx_stream_geoip2_module.so \
    && mkdir -p /etc/nginx/geoip \
    && sed -i '1iload_module \/usr\/lib\/nginx\/modules\/ngx_http_geoip2_module.so;' /etc/nginx/nginx.conf \
    && sed -i '1iload_module \/usr\/lib\/nginx\/modules\/ngx_stream_geoip2_module.so;' /etc/nginx/nginx.conf
