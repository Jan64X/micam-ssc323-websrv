FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FORCE_UNSAFE_CONFIGURE=1

RUN apt-get update && apt-get install -y \
    automake autotools-dev bc build-essential cmake cpio curl \
    file git libncurses-dev libtool lzop make rsync unzip wget \
    python3 python-is-python3 libssl-dev device-tree-compiler \
    bison flex texinfo gawk pkg-config libelf-dev \
    gcc g++ libc6-dev linux-libc-dev libstdc++-11-dev \
    ccache zlib1g-dev u-boot-tools mtd-utils squashfs-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Use host user's UID/GID to avoid permission issues
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID builder 2>/dev/null || true && \
    useradd -m -u $UID -g $GID builder 2>/dev/null || true

USER builder
