#!/bin/bash
apt-get install xorriso -y
apt-get install syslinux -y
apt-get install isolinux -y
apt-get install grub2-common -y
apt-get install grub-pc-bin -y
apt-get install grub-efi-ia32-bin -y
apt-get install grub-efi-amd64-bin -y
pushd builder
./builder.sh
popd
docker run --rm -i --privileged --mount "type=bind,src=./dist,dst=/dist" "localhost/builder" /dist/build.sh 
