#!/bin/bash

echo "🎥 ApexStream starting..."

CONFIG="/opt/apexstream/config/stream.conf"

source $CONFIG

PLAYLIST="/opt/apexstream/playlists/default.txt"

while true; do
  ffmpeg -re -f concat -safe 0 -i "$PLAYLIST" \
  -c:v libx264 -preset veryfast -b:v 2500k \
  -c:a aac -b:a 128k -f flv "$RTMP_URL/$STREAM_KEY"

  echo "⚠️ Restarting stream..."
  sleep 5
done