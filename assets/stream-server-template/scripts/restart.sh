#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
"$ROOT/scripts/stop.sh"
sleep 2
"$ROOT/scripts/start.sh" "${1:-}"
