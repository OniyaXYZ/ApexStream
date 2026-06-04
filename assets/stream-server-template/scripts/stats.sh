#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  pid="$(cat "$PID_FILE")"
  ps -p "$pid" -o etime=,%cpu=,%mem= | awk '{print "Uptime: "$1"\nCPU: "$2"%\nRAM: "$3"%"}'
  tail -n 80 "$LOG_FILE" | grep -E "bitrate=|frame=|drop=" | tail -n 5 || true
else
  echo "Stream stopped"
fi
