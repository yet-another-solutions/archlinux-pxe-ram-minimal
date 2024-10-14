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
mkdir ./dist_iso
mkdir -P ./dist_iso/EFI/BOOT
mkdir -P ./dist_iso/isolinux
mkdir -P ./dist_iso/boot/grub
yes | cp /usr/lib/grub/x86_64-efi/monolithic/grubx64.efi ./dist_iso/EFI/BOOT/BOOTX64.EFI
yes | cp /usr/lib/ISOLINUX/isolinux.bin ./dist_iso/isolinux/isolinux.bin
yes | cp ./dist/kernel.img ./dist_iso/kernel.img
yes | cp ./dist/initramfs.img ./dist_iso/initramfs.img
yes | cp ./dist/rootfs.img ./dist_iso/rootfs.img
yes | cp ./dist/isolinux.cfg ./dist_iso/isolinux.cfg
yes | cp ./dist/grub.cfg ./dist_iso/boot/grub/grub.cfg
xorriso -as mkisofs \
  -r -V 'Archlinux' \
  -o ./dist/iso.iso \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -boot-load-size 4 -boot-info-table -no-emul-boot \
  -eltorito-alt-boot \
  -e EFI/BOOT/BOOTX64.EFI
  -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
  dist_iso
