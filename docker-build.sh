#!/bin/bash
# Build firmware using Docker (avoids host toolchain issues)

set -e

IMAGE_NAME="openipc-builder"
TARGET="${1:-minimal}"

echo "=== Building OpenIPC firmware ($TARGET) in Docker ==="

# Build the Docker image if it doesn't exist
if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
    echo "Building Docker image..."
    docker build -t "$IMAGE_NAME" \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        .
fi

# Run the build
echo "Starting build..."
docker run --rm -it \
    -v "$(pwd)":/build \
    -e HOME=/home/builder \
    -w /build \
    "$IMAGE_NAME" \
    make PWD=/build TARGET=/build/output "$TARGET"

echo "=== Build complete! ==="
echo "Output in: output/images/"
ls -lh output/images/*.ssc323* 2>/dev/null || echo "(no images yet)"
