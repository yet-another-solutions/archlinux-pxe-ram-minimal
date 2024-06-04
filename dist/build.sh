#!/bin/bash

dd if=/dev/zero of=/mnt/kernel_builder.img bs=1M count=3072
mkfs.ext4 /mnt/kernel_builder.img
mount --mkdir /mnt/kernel_builder.img /mnt/main/kernel_builder

pacstrap -K /mnt/main/kernel_builder base linux squashfs-tools

arch-chroot /mnt/main/kernel_builder /bin/bash -c "echo \"\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/kernel_builder /bin/bash -c "echo \"default_mount_handler() {\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/kernel_builder /bin/bash -c "echo \"    mount /rootfs /new_root\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/kernel_builder /bin/bash -c "echo \"}\" >> /usr/lib/initcpio/init_functions"
arch-chroot /mnt/main/kernel_builder /bin/bash -c "sed -i \"s/MODULES=.*/MODULES=(loop squashfs virtio virtio_net virtio_blk virtio_scsi virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring virtio_console virtion_balloon xen-blkfront xen-fbfront xenfs xen-netfront xen-kbdfront)/g\" /etc/mkinitcpio.conf"
arch-chroot /mnt/main/kernel_builder /bin/bash -c "mkinitcpio -P"

cp /mnt/main/kernel_builder/boot/vmlinuz-linux /dist/kernel.img
cp /mnt/main/kernel_builder/boot/initramfs-linux.img /dist/initramfs.img

umount -R -f /mnt/main/kernel_builder
rm -rf /mnt/main/kernel_builder
rm -rf /mnt/kernel_builder.img

mkdir -p /mnt/main/rootfs
mkdir -p /mnt/main/squash_root

pacstrap -K /mnt/main/rootfs base

mksquashfs /mnt/main/rootfs /mnt/main/squash_root/rootfs

pushd /mnt/main/squash_root
LC_ALL=C.UTF-8 find * -printf '%p\0' | LC_ALL=C.UTF-8 sort -z | LC_ALL=C.UTF-8 bsdtar --uid 0 --gid 0 --null -cnf - -T - | LC_ALL=C.UTF-8 bsdtar --null -cf - --format=newc @- | zstd > /dist/rootfs.img
popd

chmod 666 /dist/*.img
