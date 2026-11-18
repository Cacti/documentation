#!/usr/bin/env bash
# Build the PDF and text manual editions in the same environment as CI.
#
# Copyright (c) 2004-2026 The Cacti Group. GPL-2.0-or-later.
#
# Host builds embed whatever fonts the host provides (Arial on macOS, for
# example), so their PDFs differ from the published editions. This script runs
# the CI build in Ubuntu 24.04 with the CI font and library packages and the
# locked Python toolchain, then returns the outputs to the caller's account.
#
# Usage: bin/build_manuals_in_container.sh [build_pdf_docs.py arguments]
# Default arguments: --only manual --companions
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
image='ubuntu:24.04@sha256:73b999393d07f2bf65a40373778a44dc9a6d54ad7718d29247d8ff9413c4d6a8'
uv_version='0.12.23'
# A worktree keeps its Git metadata outside the checkout; mount it read-only at
# the same path so the builder can record the source revision.
git_dir=$(git -C "$root" rev-parse --absolute-git-dir)
git_common=$(cd "$(git -C "$root" rev-parse --git-common-dir)" && pwd)
if [ "$#" -eq 0 ]; then
	set -- --only manual --companions
fi

docker run --rm -i \
	-v "$root:/src" -w /src \
	-v "$git_dir:$git_dir:ro" -v "$git_common:$git_common:ro" \
	-e HOST_UID="$(id -u)" -e HOST_GID="$(id -g)" -e UV_VERSION="$uv_version" \
	"$image" bash -s -- "$@" <<'CONTAINER'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq --no-install-recommends ca-certificates curl git \
	libpango-1.0-0 libpangoft2-1.0-0 libharfbuzz-subset0 \
	fonts-dejavu-core fonts-dejavu-extra poppler-utils >/dev/null

case "$(uname -m)" in
	x86_64) arch=x86_64; sum=9167d72b3319674b6303c4cbe071854bba13ebdf3d76b1a7cbdc175471fb66d6 ;;
	aarch64) arch=aarch64; sum=6524bd338177ed50d035d39354e12545e993bbeba2ecbddf0480c5b3a81d313f ;;
	*) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
archive="uv-$arch-unknown-linux-gnu.tar.gz"
curl -fsSL -o "/tmp/$archive" "https://github.com/astral-sh/uv/releases/download/$UV_VERSION/$archive"
echo "$sum  /tmp/$archive" | sha256sum -c --quiet
tar -xzf "/tmp/$archive" -C /usr/local/bin --strip-components=1

git config --global --add safe.directory '*'
status=0
uv run --locked --python 3.12.12 --script bin/build_pdf_docs.py "$@" || status=$?
chown -R "$HOST_UID:$HOST_GID" resource manual-artifacts 2>/dev/null || true
exit "$status"
CONTAINER
