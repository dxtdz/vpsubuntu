FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
WORKDIR /root

# update base
RUN apt update

# install XFCE + VNC + noVNC deps
RUN apt install -y \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    curl \
    firefox \
    git \
    wget \
    xz-utils \
    software-properties-common \
    fonts-zenhei \
    --no-install-recommends

# install Python 3.12
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
RUN apt install -y \
    python3.12 \
    python3.12-venv \
    python3-pip

# set python3 -> python3.12
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# download noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mv noVNC-1.2.0 /noVNC
RUN rm v1.2.0.tar.gz

# setup VNC
RUN mkdir -p $HOME/.vnc
RUN echo "xt" | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

# VNC startup (XFCE only – tránh trùng taskbar)
RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec dbus-launch --exit-with-session xfce4-session &' \
> $HOME/.vnc/xstartup
RUN chmod +x $HOME/.vnc/xstartup

# copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 6080
CMD ["/run.sh"]
