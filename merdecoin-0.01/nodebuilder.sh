#!/bin/bash/
#Install git and all other required dependencies, clone the required merdecoin version and compile prior to the required changes
sudo apt-get install git
sudo apt-get install autoconf libtool pkg-config libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libevent-dev libqt4-dev libcanberra-gtk-module
sudo apt install autoconf
mkdir -p merdecoin && cd merdecoin
git clone https://github.com/merdecoin/merdecoin.git
sudo apt-get install build-essential
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
mkdir -p build
BDB_PREFIX=$(pwd)/build
../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
make install
cd ../..
cd merdecoin
git checkout v0.18.0
./autogen.sh
./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/" --with-gui --with-incompatible-bdb
make
# Now we have a working copy of the bitcoun client we can modify it to work on our own network
find . -type f -exec sed -i 's/Merdecoin /Merdecoin /g' {} +
find . -type f -exec sed -i 's/MRD/MRD/g' {} +
