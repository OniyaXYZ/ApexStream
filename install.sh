#!/bin/bash

echo "🚀 Installing ApexStream..."

apt update -y
apt install -y ffmpeg git

mkdir -p /opt/apexstream
cd /opt/apexstream

git clone https://github.com/OniyaXYZ/ApexStream.git .

chmod +x scripts/*.sh

echo "✅ Installed ApexStream"
echo "Run: ./scripts/start.sh"