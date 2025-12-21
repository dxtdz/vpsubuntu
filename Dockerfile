# Sử dụng image Ubuntu có sẵn noVNC (Giao diện web)
FROM thuonghai2711/ubuntu-novnc-pulseaudio:22.04

# Thiết lập các biến môi trường hệ thống
ENV VNC_PASSWD=123456
ENV PORT=10000
ENV AUDIO_PORT=1699
ENV WEBSOCKIFY_PORT=6900
ENV VNC_PORT=5900
ENV SCREEN_WIDTH=1024
ENV SCREEN_HEIGHT=768
ENV SCREEN_DEPTH=24

# Chuyển sang quyền root để cài đặt phần mềm
USER root

# 1. Cập nhật hệ thống và cài đặt Chrome
RUN apt-get update && apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Cloudflared để chạy Tunnel cố định
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared-linux-amd64.deb && \
    rm cloudflared-linux-amd64.deb

# Render yêu cầu lắng nghe cổng 10000
EXPOSE 10000

# Lệnh khởi chạy: 
# - Chạy supervisor (quản lý giao diện Ubuntu)
# - Chạy cloudflared tunnel (dùng token hoặc link ngẫu nhiên)
CMD ["/bin/bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf & sleep 7 && if [ -z \"$TUNNEL_TOKEN\" ]; then cloudflared tunnel --no-autoupdate --url http://localhost:10000; else cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN; fi"]
