#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"

src="${1:?video path required}"
name="$(basename "$src")"
dest="$ROOT/videos/$name"
mkdir -p "$ROOT/videos"
cp "$src" "$dest"
printf "file '%s'\n" "$dest" >> "$ROOT/playlists/${DEFAULT_PLAYLIST}.txt"
echo "Added $name"
