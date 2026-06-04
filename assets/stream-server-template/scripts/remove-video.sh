#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"

name="${1:?video name required}"
rm -f "$ROOT/videos/$name"
tmp="$(mktemp)"
grep -v "/$name'" "$ROOT/playlists/${DEFAULT_PLAYLIST}.txt" > "$tmp" || true
mv "$tmp" "$ROOT/playlists/${DEFAULT_PLAYLIST}.txt"
echo "Removed $name"
