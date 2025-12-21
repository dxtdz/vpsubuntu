#!/bin/bash
set -e

echo "[+] Starting VNC"

# kill cũ nếu có
vncserver -kill :1 >/dev/null 2>&1 || true

# start VNC
vncserver :1 -geometry 1280x720 -depth 24

# chờ VNC lên (Render cần delay)
sleep 6

echo "[+] Starting noVNC"

cd /noVNC
exec ./utils/launch.sh \
  --vnc localhost:5901 \
  --listen 6080 \
  --heartbeat 30
