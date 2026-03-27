#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

builder_image="${TYPEBOT_BUILDER_IMAGE:-${TYPEBOT_BUILDER_TAG:-typebot-builder:local}}"
viewer_image="${TYPEBOT_VIEWER_IMAGE:-${TYPEBOT_VIEWER_TAG:-typebot-viewer:local}}"

cd "${repo_root}"

build_scope_image() {
  local scope="$1"
  local image_name="$2"
  echo "Building ${scope} image: ${image_name}"
  docker build --build-arg "SCOPE=${scope}" -t "${image_name}" .
}

build_scope_image builder "${builder_image}" &
builder_pid=$!

build_scope_image viewer "${viewer_image}" &
viewer_pid=$!

wait "${builder_pid}"
wait "${viewer_pid}"

echo "Done."
echo "You can now run:"
echo "TYPEBOT_BUILDER_IMAGE=${builder_image} TYPEBOT_VIEWER_IMAGE=${viewer_image} docker compose -f docker-compose.local-portainer.yml up -d"
