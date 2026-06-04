# Stream Server

Production-style Ubuntu VPS livestream starter using FFmpeg, playlists, quality profiles, encoder detection, logs, and systemd recovery.

## Install On Ubuntu

```bash
sudo apt update
sudo apt install -y ffmpeg coreutils procps util-linux
sudo ./install.sh
```

Then edit:

```bash
sudo nano /opt/stream-server/config/stream.conf
```

Set `RTMP_URL` and `STREAM_KEY`.

## Commands

```bash
stream start high
stream stop
stream restart medium
stream status
stream logs
stream stats
stream add /path/to/video.mp4
stream remove video.mp4
stream playlist show
stream playlist shuffle
stream playlist loop on
stream encoder auto
```

## Layout

```text
config/
videos/
logs/
cache/
scripts/
playlists/
systemd/
```

Use `videos/` for media files and `playlists/default.txt` for playlist order. The systemd service restarts failed streams automatically.
