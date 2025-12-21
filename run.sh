#!/bin/bash
set -e

echo "[+] Starting VNC server"

# kill old session nếu có
vncserver -kill :1 >/dev/null 2>&1 || true

# start VNC
vncserver :1 -geometry 1280x720 -depth 24

# Render cần delay để VNC mở cổng
sleep 6

echo "[+] Starting noVNC"

cd /noVNC

# chạy foreground để Render không kill container
exec ./utils/launch.sh \
  --vnc localhost:5901 \
  --listen 6080 \
  --heartbeat 30
