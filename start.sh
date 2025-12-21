#!/bin/bash
set -e

# Start noVNC server
supervisord -c /etc/supervisor/conf.d/supervisord.conf &

# Wait for noVNC to start
sleep 5

# Start cloudflared tunnel
echo "Starting cloudflared tunnel..."
/usr/local/bin/cloudflared tunnel --no-autoupdate --url http://localhost:10000 &

# Wait for cloudflared
sleep 10

# Start socat for Render previews
socat TCP-LISTEN:$PORT,fork,reuseaddr TCP:127.0.0.1:10000 &

# Keep container running
tail -f /dev/null
