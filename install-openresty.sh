#!/bin/sh
set -e

cd /tmp

export PATH=/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

OPENSSL_VERSION=1.0.2f
PCRE_VERSION=8.38
OPENRESTY_VERSION=1.9.7.3

curl -o openssl.tar.gz -L https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
tar -zvxf openssl.tar.gz

curl -o pcre.tar.gz -L ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz
tar -zxvf pcre.tar.gz

curl -o openresty.tar.gz -L https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz
tar -zxvf openresty.tar.gz
cd openresty-$OPENRESTY_VERSION/

# assuming your have 4 spare logical CPU cores
./configure --with-openssl=../openssl-$OPENSSL_VERSION \
            --with-pcre=../pcre-$PCRE_VERSION \
            --with-pcre-jit \
            --with-ipv6 \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            -j4
make -j4
make install

rm -rf /tmp/*
