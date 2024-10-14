#!/bin/bash
apt-get install xorriso -y
pushd builder
./builder.sh
popd
docker run --rm -i --privileged --mount "type=bind,src=./dist,dst=/dist" "localhost/builder" /dist/build.sh 
