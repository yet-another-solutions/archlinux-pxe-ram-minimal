#!/bin/bash

dd if=/dev/zero of=/mnt/main.img bs=1M count=3072
mkfs.ext4 /mnt/main.img
mount --mkdir /mnt/main.img /mnt/main/new_root


#RUN mkdir -p /mnt/main/new_root

#RUN echo 'root:1000:5000' > /etc/subuid
#RUN echo 'root:1000:5000' > /etc/subgid

pacstrap -K /mnt/main/new_root base linux

arch-chroot /mnt/main/new_root /bin/bash -c "echo \"\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/new_root /bin/bash -c "echo \"default_mount_handler() {\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/new_root /bin/bash -c "echo \"    mount /rootfs /new_root\" >> /usr/lib/initcpio/init_functions"
# arch-chroot /mnt/main/new_root /bin/bash -c "echo \"    msg \\\"Doing nothing\\\"\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/new_root /bin/bash -c "echo \"}\" >> /usr/lib/initcpio/init_functions"

arch-chroot /mnt/main/new_root /bin/bash -c "mkinitcpio -P"

mkdir -p /mnt/main/squash_root

mksquashfs /mnt/main/new_root /mnt/main/squash_root/rootfs

pushd /mnt/main/squash_root
#ls
#echo "looking"
#LC_ALL=C.UTF-8 find * -mindepth 1 -name "rootfs" -printf '%P\0'
#echo "looked"
#echo "debug find"
#find * -mindepth 1 -name "rootfs"
#echo "debug found"
LC_ALL=C.UTF-8 find * -name "rootfs" -printf '%P\0' | LC_ALL=C.UTF-8 sort -z | LC_ALL=C.UTF-8 bsdtar --uid 0 --gid 0 --null -cnf - -T - | LC_ALL=C.UTF-8 bsdtar --null -cf - --format=newc @- | zstd > /dist/rootfs.img
popd

cp /mnt/main/new_root/boot/vmlinuz-linux /dist/kernel.img
cp /mnt/main/new_root/boot/initramfs-linux.img /dist/initramfs.img

chmod 666 /dist/*.img
