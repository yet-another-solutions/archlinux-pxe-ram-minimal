#!/bin/bash
pushd builder
./builder.sh
popd
docker run --rm -i --privileged --mount "type=bind,src=./dist,dst=/dist" "localhost/builder" /dist/build.sh 
mkdir -p ./dist_iso/EFI/BOOT
mkdir -p ./dist_iso/isolinux
mkdir -p ./dist_iso/boot/grub
cp /usr/lib/grub/x86_64-efi/monolithic/grubx64.efi ./dist_iso/EFI/BOOT/BOOTX64.EFI
cp /usr/lib/ISOLINUX/isolinux.bin ./dist_iso/isolinux/isolinux.bin
cp ./dist/kernel.img ./dist_iso/kernel.img
cp ./dist/initramfs.img ./dist_iso/initramfs.img
cp ./dist/rootfs.img ./dist_iso/rootfs.img
cp ./dist/isolinux.cfg ./dist_iso/isolinux/isolinux.cfg
cp ./dist/grub.cfg ./dist_iso/boot/grub/grub.cfg
xorriso -as mkisofs \
  -r -V 'Archlinux' \
  -o ./dist/iso.iso \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -boot-load-size 4 -boot-info-table -no-emul-boot \
  -eltorito-alt-boot \
  -e EFI/BOOT/BOOTX64.EFI \
  -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
  dist_iso
