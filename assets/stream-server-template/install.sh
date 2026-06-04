#!/bin/bash

echo "🚀 Installing Stream Server..."

apt update -y
apt install -y ffmpeg coreutils procps util-linux git

mkdir -p /opt/stream-server
cd /opt/stream-server

# copy project files (local install or repo install)
git clone https://github.com/OniyaXYZ/ApexStream.git .

chmod +x scripts/*.sh

# create runtime folders
mkdir -p config videos logs cache playlists

echo "⚙️ Creating default config..."

cat > config/stream.conf <<EOL
RTMP_URL=rtmp://live.twitch.tv/app
STREAM_KEY=changeme
QUALITY=high
EOL

echo "🛠 Installing systemd service..."

cp systemd/stream-server.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable stream-server

echo "✅ Installation complete"
echo "👉 Edit config: nano /opt/stream-server/config/stream.conf"
echo "👉 Start: systemctl start stream-server"