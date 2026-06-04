#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
mode="${1:-auto}"

case "$mode" in
  auto|nvenc|qsv|vaapi|x264) ;;
  *) echo "Use auto, nvenc, qsv, vaapi, or x264" >&2; exit 1 ;;
esac

sed -i "s/^ENCODER_MODE=.*/ENCODER_MODE=\"$mode\"/" "$ROOT/config/encoder.conf"
echo "Encoder mode set to $mode"
