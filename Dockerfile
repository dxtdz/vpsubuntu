FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt full bộ công cụ bạn cần
RUN apt update && apt install -y \
    wget curl git xz-utils dbus-x11 \
    fonts-wqy-zenhei xfce4 xfce4-terminal \
    tightvncserver openssh-server \
    firefox-geckodriver \
    gnome-system-monitor mate-system-monitor \
    wine wine32 wine64 qemu-kvm \
    && apt clean

# Cài đặt noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz \
    && tar -xvf v1.2.0.tar.gz \
    && rm v1.2.0.tar.gz

# Tạo file run.sh trực tiếp trong Dockerfile để tránh lỗi copy
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Render sử dụng port động, nhưng mình vẫn EXPOSE để dễ quản lý
EXPOSE 8900

CMD ["/run.sh"]
