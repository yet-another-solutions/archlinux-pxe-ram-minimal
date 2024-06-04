FROM docker.io/alpine:3.19 AS bootstrap

RUN apk add --no-cache coreutils sequoia-sq tar wget zstd

WORKDIR /tmp

RUN wget https://mirror.rackspace.com/archlinux/iso/latest/b2sums.txt
RUN wget https://mirror.rackspace.com/archlinux/iso/latest/sha256sums.txt
RUN wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst
RUN wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst.sig
RUN sq --force wkd get pierre@archlinux.org -o release-key.pgp

RUN b2sum --ignore-missing -c b2sums.txt
RUN sha256sum --ignore-missing -c sha256sums.txt
RUN sq verify --signer-file release-key.pgp --detached archlinux-bootstrap-x86_64.tar.zst.sig archlinux-bootstrap-x86_64.tar.zst

WORKDIR /

RUN mkdir /rootfs
RUN tar xf /tmp/archlinux-bootstrap-x86_64.tar.zst --numeric-owner -C /rootfs

FROM scratch as builder
#USER root
COPY --from=bootstrap /rootfs/root.x86_64 /

RUN pacman-key --init
RUN pacman-key --populate
RUN echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

RUN pacman --noconfirm -Syu arch-install-scripts squashfs-tools e2fsprogs
