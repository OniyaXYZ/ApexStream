#!/usr/bin/env bash
set -euo pipefail

source_playlist="${1:?source playlist required}"
target_playlist="${2:?target playlist required}"
ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/playlist.conf"

: > "$target_playlist"

if [[ -n "$INTRO_VIDEO" ]]; then
  printf "file '%s'\n" "$INTRO_VIDEO" >> "$target_playlist"
fi

grep "^file " "$source_playlist" >> "$target_playlist" || true

if [[ -n "$OUTRO_VIDEO" ]]; then
  printf "file '%s'\n" "$OUTRO_VIDEO" >> "$target_playlist"
fi
