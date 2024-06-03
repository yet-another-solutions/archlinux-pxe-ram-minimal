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

#RUN arch-chroot /mnt/main/new_root /bin/bash -c "mkdir -p /mnt/main/squash_root"

#RUN arch-chroot /mnt/main/new_root /bin/bash -c  "mksquashfs /mnt/main/new_root /mnt/main/squash_root/rootfs"

#RUN arch-chroot /mnt/main/new_root /bin/bash -c  "cd /mnt/main/squash_root && LC_ALL=C.UTF-8 find * -mindepth 1 -name \"rootfs\" -printf '%P\0' | LC_ALL=C.UTF-8 sort -z | LC_ALL=C.UTF-8 bsdtar --uid 0 --gid 0 --null -cnf - -T - | LC_ALL=C.UTF-8 bsdtar --null -cf - --format=newc @- | zstd >> /mnt/rootfs.img"
#RUN arch-chroot /mnt/main/new_root /bin/bash -c  "cp /mnt/main/new_root/boot/vmlinux-linux /mnt/kernel.img"
#RUN arch-chroot /mnt/main/new_root /bin/bash -c  "cp /mnt/main/new_root/boot/initramfs-linux /mnt/initramfs.img"
