#!/bin/bash

echo "[+] User: $(whoami)"
cd ~

# clean old vnc
vncserver -kill :1 >/dev/null 2>&1 || true

# start vnc (background)
vncserver :1 -geometry 1280x720 -depth 24

# ĐỢI VNC LÊN CỔNG 5901 (CỰC QUAN TRỌNG)
echo "[+] Waiting for VNC on port 5901..."
for i in {1..10}; do
  nc -z localhost 5901 && break
  sleep 1
done

# start noVNC (CHỈ ĐỊNH RÕ DISPLAY)
cd /noVNC
exec ./utils/launch.sh \
  --vnc localhost:5901 \
  --listen 6080 \
  --heartbeat 30
