#!/bin/bash
pushd builder
./builder.sh
popd
docker run --rm -i --mount "type=bind,src=./dist,dst=/dist" "localhost/builder" /dist/build.sh 
