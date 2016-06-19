from ubuntu:16.04

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential make curl wget vim git perl \
                       libreadline-dev libncurses5-dev libpcre3-dev \
                       libssl-dev

RUN apt-get -y install python-pip python3-pip
RUN pip install supervisor

RUN export OPENRESTY_VERSION=1.9.15.1 && \
    cd /tmp && \
    curl -o openresty.tar.gz -L https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz && \
    tar -zxvf openresty.tar.gz && \
    cd openresty-$OPENRESTY_VERSION && \
    ./configure --with-threads \
                --with-file-aio \
                --with-pcre-jit \
                --with-ipv6 \
                --with-http_gunzip_module \
                --with-http_gzip_static_module \
                --with-stream \
                --with-stream_ssl_module \
                -j4 && \
    make -j4 && \
    make install

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log
RUN ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# note openresty nginx will use /usr/local/openresty/nginx/conf/nginx.conf by default.
EXPOSE 80
ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
