#!/bin/bash

echo "[+] User: $(whoami)"
cd ~

# kill old VNC if exists
vncserver -kill :1 >/dev/null 2>&1 || true

# start VNC
vncserver :1 -geometry 1280x720 -depth 24

# start noVNC (main process)
cd /noVNC
exec ./utils/launch.sh --vnc localhost:5901 --listen 6080
