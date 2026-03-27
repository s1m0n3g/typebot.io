#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

builder_image="${TYPEBOT_BUILDER_IMAGE:-${TYPEBOT_BUILDER_TAG:-typebot-builder:local}}"
viewer_image="${TYPEBOT_VIEWER_IMAGE:-${TYPEBOT_VIEWER_TAG:-typebot-viewer:local}}"

cd "${repo_root}"

echo "Building builder image: ${builder_image}"
docker build --build-arg SCOPE=builder -t "${builder_image}" .

echo "Building viewer image: ${viewer_image}"
docker build --build-arg SCOPE=viewer -t "${viewer_image}" .

echo "Done."
echo "You can now run:"
echo "TYPEBOT_BUILDER_IMAGE=${builder_image} TYPEBOT_VIEWER_IMAGE=${viewer_image} TYPEBOT_IMAGE_PULL_POLICY=never docker compose -f docker-compose.local-portainer.yml up -d"
