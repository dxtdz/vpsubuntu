FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# ---- base packages ----
RUN apt update && apt install -y \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    curl \
    git \
    wget \
    xz-utils \
    ca-certificates \
    net-tools \
    --no-install-recommends && \
    apt clean && rm -rf /var/lib/apt/lists/*

# ---- noVNC ----
RUN git clone https://github.com/novnc/noVNC.git /noVNC && \
    git clone https://github.com/novnc/websockify /noVNC/utils/websockify

# ---- VNC config ----
RUN mkdir -p /root/.vnc && \
    echo "xt" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    echo '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec dbus-launch xfce4-session &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# ---- run script ----
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 6080

CMD ["/bin/bash", "/run.sh"]
