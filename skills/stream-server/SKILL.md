---
name: stream-server
description: Build, customize, or troubleshoot an Ubuntu VPS livestream system using FFmpeg, playlists, stream targets, encoder detection, systemd recovery, and optional dashboard/API components.
---

# VPS Stream Server

Use this skill when the user asks to create or improve a self-hosted livestreaming setup on an Ubuntu VPS, especially when they want something more maintainable than a one-off FFmpeg command.

## Default Architecture

Recommend and scaffold a `stream-server/` layout with:

- `config/stream.conf` for RTMP target, stream key, defaults, runtime paths, and feature toggles.
- `config/encoder.conf` for quality profiles and encoder preference.
- `config/playlist.conf` for loop, shuffle, intro, outro, fallback, and playlist selection.
- `videos/` for source media.
- `playlists/` for FFmpeg concat playlists.
- `logs/` for controller and FFmpeg logs.
- `cache/` for temporary concat files and RAM-cache staging.
- `scripts/` for start, stop, restart, status, playlist, encoder, logs, stats, and video management.
- `systemd/livestream.service` for auto recovery.

## Implementation Priorities

When generating a starter system:

1. Keep the first version shell-native and deployable on Ubuntu without requiring a dashboard.
2. Use FFmpeg concat playlists for playlist mode.
3. Support profile names `low`, `medium`, `high`, and `ultra`.
4. Detect encoders in this order unless the user overrides it: `h264_nvenc`, `h264_qsv`, `h264_vaapi`, then `libx264`.
5. Use systemd for restart recovery with `Restart=always` and `RestartSec=5`.
6. Keep stream keys in config files and remind users to protect them with filesystem permissions.
7. Prefer practical commands the user can run on Ubuntu.

## CLI Behavior

Model CLI commands around:

- `stream start [profile]`
- `stream stop`
- `stream restart [profile]`
- `stream status`
- `stream logs`
- `stream stats`
- `stream add <video>`
- `stream remove <video>`
- `stream playlist show`
- `stream playlist shuffle`
- `stream playlist loop on|off`
- `stream encoder auto|nvenc|qsv|vaapi|x264`
- `stream schedule <time> <video-or-playlist>`

## FFmpeg Guidance

Use these optimization ideas in generated FFmpeg commands when appropriate:

- `-re`
- `-stream_loop -1` for repeated single fallback input.
- `-thread_queue_size 4096`
- `-rtbufsize 512M`
- profile-specific bitrate, buffer size, and keyframe interval.
- `-g` equal to two seconds of frames for common RTMP platforms.
- `-preset` based on encoder and profile.
- `-f flv "$RTMP_URL/$STREAM_KEY"` for RTMP output.

## Dashboard Guidance

If the user asks for a web dashboard, suggest a phased stack:

- FastAPI controller/API.
- Redis for queue/cache/state when needed.
- React dashboard for controls, uploads, stats, and logs.
- Nginx-RTMP or SRT relay when OBS compatibility or multi-input relay is needed.

Do not overbuild the dashboard unless the user asks for it. For a first deployable plugin output, prioritize a working CLI/systemd streamer.

## Generator Script

This plugin includes `scripts/new-stream-server.ps1`, which creates a starter `stream-server/` project from local templates.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\LOQ\plugins\vps-stream-server\scripts\new-stream-server.ps1 -Destination C:\path\to\stream-server
```

After generation, inspect `README.md` in the created project for Ubuntu install and deployment steps.
