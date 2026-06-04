#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  pid="$(cat "$PID_FILE")"
  echo "Stream running: PID $pid"
  ps -p "$pid" -o pid,etime,%cpu,%mem,cmd
else
  echo "Stream stopped"
fi
