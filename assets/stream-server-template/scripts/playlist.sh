#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"
source "$ROOT/config/playlist.conf"

action="${1:-show}"
playlist="$ROOT/playlists/${DEFAULT_PLAYLIST}.txt"

case "$action" in
  show) cat "$playlist" ;;
  shuffle) grep "^file " "$playlist" | shuf > "$ROOT/cache/shuffled.txt"; mv "$ROOT/cache/shuffled.txt" "$playlist"; echo "Shuffled playlist" ;;
  loop)
    value="${2:?use on or off}"
    sed -i "s/^PLAYLIST_LOOP=.*/PLAYLIST_LOOP=\"$value\"/" "$ROOT/config/playlist.conf"
    echo "Playlist loop set to $value"
    ;;
  *) echo "Usage: stream playlist {show|shuffle|loop on|loop off}" ;;
esac
