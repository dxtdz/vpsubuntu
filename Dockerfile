# Sử dụng image Ubuntu noVNC có sẵn
FROM thuonghai2711/ubuntu-novnc-pulseaudio:22.04

# Thiết lập các biến môi trường
ENV VNC_PASSWD=xt
ENV PORT=10000
ENV SCREEN_WIDTH=1024
ENV SCREEN_HEIGHT=768
ENV SCREEN_DEPTH=24

USER root

# 1. Cài đặt Google Chrome
RUN apt-get update && apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared-linux-amd64.deb && \
    rm cloudflared-linux-amd64.deb

# 3. Cài đặt Rclone (Để dùng ổ đĩa ảo sau này)
RUN apt-get update && apt-get install -y rclone fuse3 && rm -rf /var/lib/apt/lists/*

# Mở cổng 10000 cho Render
EXPOSE 10000

# Lệnh khởi chạy tổng hợp:
# - Sửa lỗi Supervisor chạy quyền root
# - Khởi động giao diện Ubuntu ngầm
# - Đợi 10 giây để hệ thống lên hẳn rồi mới chạy Tunnel vào cổng 80
CMD ["/bin/bash", "-c", "sed -i '/\[supervisord\]/a user=root' /etc/supervisor/supervisord.conf && (/usr/bin/supervisord -c /etc/supervisor/supervisord.conf &) && sleep 10 && if [ -z \"$TUNNEL_TOKEN\" ]; then cloudflared tunnel --no-autoupdate --url http://localhost:80; else cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN; fi"]
