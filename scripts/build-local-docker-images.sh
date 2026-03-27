#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

builder_tag="${TYPEBOT_BUILDER_TAG:-typebot-builder:local}"
viewer_tag="${TYPEBOT_VIEWER_TAG:-typebot-viewer:local}"

cd "${repo_root}"

echo "Building builder image: ${builder_tag}"
docker build --build-arg SCOPE=builder -t "${builder_tag}" .

echo "Building viewer image: ${viewer_tag}"
docker build --build-arg SCOPE=viewer -t "${viewer_tag}" .

echo "Done."
echo "You can now run: docker compose -f docker-compose.local-portainer.yml up -d"
