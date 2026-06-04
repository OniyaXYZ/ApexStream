#!/usr/bin/env bash
set -euo pipefail

ROOT="${STREAM_ROOT:-/opt/stream-server}"
source "$ROOT/config/stream.conf"
source "$ROOT/config/encoder.conf"
source "$ROOT/config/playlist.conf"

PROFILE="${1:-$DEFAULT_PROFILE}"
PLAYLIST="$ROOT/playlists/${DEFAULT_PLAYLIST}.txt"
CONCAT_FILE="$ROOT/cache/concat.txt"
mkdir -p "$ROOT/logs" "$ROOT/cache"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Stream already running with PID $(cat "$PID_FILE")"
  exit 0
fi

bitrate_var="$(echo "${PROFILE}_BITRATE" | tr '[:lower:]' '[:upper:]')"
bufsize_var="$(echo "${PROFILE}_BUFSIZE" | tr '[:lower:]' '[:upper:]')"
BITRATE="${!bitrate_var:-$MEDIUM_BITRATE}"
BUFSIZE="${!bufsize_var:-$MEDIUM_BUFSIZE}"
GOP=$((TARGET_FPS * KEYFRAME_SECONDS))

encoder="$("$ROOT/scripts/detect-encoder.sh" "$ENCODER_MODE")"

"$ROOT/scripts/build-playlist.sh" "$PLAYLIST" "$CONCAT_FILE"

if [[ ! -s "$CONCAT_FILE" ]]; then
  if [[ -n "$FALLBACK_VIDEO" ]]; then
    printf "file '%s'\n" "$FALLBACK_VIDEO" > "$CONCAT_FILE"
  else
    echo "Playlist is empty and no fallback video is configured." >&2
    exit 1
  fi
fi

echo "Starting stream profile=$PROFILE encoder=$encoder bitrate=$BITRATE" | tee -a "$LOG_FILE"

loop_args=()
if [[ "$PLAYLIST_LOOP" == "on" ]]; then
  loop_args=(-stream_loop -1)
fi

nohup "$FFMPEG_BIN" \
  -hide_banner \
  -re \
  -thread_queue_size 4096 \
  -rtbufsize 512M \
  "${loop_args[@]}" \
  -f concat \
  -safe 0 \
  -i "$CONCAT_FILE" \
  -c:v "$encoder" \
  -b:v "$BITRATE" \
  -maxrate "$BITRATE" \
  -bufsize "$BUFSIZE" \
  -g "$GOP" \
  -r "$TARGET_FPS" \
  -pix_fmt yuv420p \
  -c:a aac \
  -b:a 160k \
  -ar 44100 \
  -f flv "${RTMP_URL}/${STREAM_KEY}" \
  >>"$LOG_FILE" 2>>"$ERROR_LOG_FILE" &

echo $! > "$PID_FILE"
echo "Started stream with PID $(cat "$PID_FILE")"
