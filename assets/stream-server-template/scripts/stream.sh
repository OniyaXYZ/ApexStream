#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
  start) "$ROOT/scripts/start.sh" "${1:-}" ;;
  stop) "$ROOT/scripts/stop.sh" ;;
  restart) "$ROOT/scripts/restart.sh" "${1:-}" ;;
  status) "$ROOT/scripts/status.sh" ;;
  logs) tail -n 120 -f "$ROOT/logs/stream.log" "$ROOT/logs/error.log" ;;
  stats) "$ROOT/scripts/stats.sh" ;;
  add) "$ROOT/scripts/add-video.sh" "${1:?video path required}" ;;
  remove) "$ROOT/scripts/remove-video.sh" "${1:?video name required}" ;;
  playlist) "$ROOT/scripts/playlist.sh" "$@" ;;
  encoder) "$ROOT/scripts/encoder.sh" "${1:-auto}" ;;
  *)
    echo "Usage: stream {start|stop|restart|status|logs|stats|add|remove|playlist|encoder}"
    ;;
esac
