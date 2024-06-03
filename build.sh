#!/bin/bash
pushd builder
./build.sh
popd
docker run --rm -it -v "dist:/dist" "localhost/builder" /dist/build.sh 
