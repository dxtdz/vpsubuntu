FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Kích hoạt i386 để cài Wine và cập nhật hệ thống
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y --no-install-recommends \
    wget \
    curl \
    git \
    xz-utils \
    dbus-x11 \
    fonts-wqy-zenhei \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    openssh-server \
    gnome-system-monitor \
    mate-system-monitor \
    wine \
    wine32 \
    wine64 \
    qemu-kvm \
    firefox \
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt noVNC v1.2.0
RUN wget -q https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

# 3. Copy file run.sh (Đảm bảo file này nằm cùng thư mục với Dockerfile)
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Render dùng port động, nhưng mặc định thường là 8900 hoặc 10000
EXPOSE 8900

CMD ["/run.sh"]
