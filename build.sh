#!/bin/bash
pushd builder
./builder.sh
popd
docker run --rm -i -v "dist:/dist" "localhost/builder" /dist/build.sh 
