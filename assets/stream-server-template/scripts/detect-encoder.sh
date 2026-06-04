#!/usr/bin/env bash
set -euo pipefail

mode="${1:-auto}"
encoders="$(ffmpeg -hide_banner -encoders 2>/dev/null || true)"

case "$mode" in
  nvenc) echo "h264_nvenc"; exit 0 ;;
  qsv) echo "h264_qsv"; exit 0 ;;
  vaapi) echo "h264_vaapi"; exit 0 ;;
  x264) echo "libx264"; exit 0 ;;
esac

if grep -q "h264_nvenc" <<<"$encoders"; then
  echo "h264_nvenc"
elif grep -q "h264_qsv" <<<"$encoders"; then
  echo "h264_qsv"
elif grep -q "h264_vaapi" <<<"$encoders"; then
  echo "h264_vaapi"
else
  echo "libx264"
fi
