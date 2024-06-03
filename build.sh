#!/bin/bash
pushd builder
./builder.sh
popd
docker run --rm -it -v "dist:/dist" "localhost/builder" /dist/build.sh 
