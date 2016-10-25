#!/usr/bin/env bash
WANDIO_VERSION=1.0.4
BGPSTREAM_VERSION=1.1.0

apt-get -y install zlib1g-dev libbz2-dev libcurl4-openssl-dev build-essential sqlite3 python-pip python-pyramid python-pysqlite2 
(cd /home/ubuntu/deps && wget --quiet -c http://research.wand.net.nz/software/wandio/wandio-$WANDIO_VERSION.tar.gz)
tar -xf /home/ubuntu/deps/wandio-$WANDIO_VERSION.tar.gz -C /tmp


(cd /tmp/wandio-$WANDIO_VERSION && ./configure --quiet --with-http --with-zlib && make install && ldconfig)
rm -rf /tmp/wandio-$WANDIO_VERSION

(cd /home/ubuntu/deps && wget --quiet -c http://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-$BGPSTREAM_VERSION.tar.gz)
tar -xf /home/ubuntu/deps/bgpstream-$BGPSTREAM_VERSION.tar.gz -C /tmp
(cd /tmp/bgpstream-$BGPSTREAM_VERSION && ./configure --quiet && make install && ldconfig)
rm -rf /tmp/bgpstream-$BGPSTREAM_VERSION

pip install pybgpstream

mkdir /home/ubuntu/database
mkdir /home/ubuntu/src_data
