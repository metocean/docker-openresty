set -e


echo '-------- installing openresty / nginx --------'
cd /tmp
OPENRESTY_VERSION=1.9.15.1
#export PATH=/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

curl -o openresty.tar.gz -L https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz
tar -zxvf openresty.tar.gz
cd openresty-$OPENRESTY_VERSION/

# assuming your have 4 spare logical CPU cores
./configure --with-threads \
            --with-file-aio \
            --with-pcre-jit \
            --with-ipv6 \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-stream \
            --with-stream_ssl_module \
            -j4
make -j4
make install

rm -rf /tmp/*
