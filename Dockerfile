FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
WORKDIR /root

# update
RUN apt update

# install GUI + VNC + noVNC deps (Render OK)
RUN apt install -y --no-install-recommends \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    curl \
    git \
    wget \
    xz-utils \
    chromium-browser \
    fonts-wqy-zenhei \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mv noVNC-1.2.0 /noVNC
RUN rm v1.2.0.tar.gz

# VNC config
RUN mkdir -p $HOME/.vnc
RUN echo "xt" | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec dbus-launch --exit-with-session xfce4-session &' \
> $HOME/.vnc/xstartup
RUN chmod +x $HOME/.vnc/xstartup

# run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 6080
CMD ["/run.sh"]
