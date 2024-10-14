#!/bin/bash
apt-get install xorriso -y
apt-get install syslinux -y
apt-get install isolinux -y
pushd builder
./builder.sh
popd
docker run --rm -i --privileged --mount "type=bind,src=./dist,dst=/dist" "localhost/builder" /dist/build.sh 
