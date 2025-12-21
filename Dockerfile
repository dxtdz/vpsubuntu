FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
WORKDIR /root

RUN apt update

RUN apt install -y --no-install-recommends \
    software-properties-common \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    curl \
    git \
    wget \
    xz-utils \
    chromium-browser \
    fonts-wqy-zenhei

# Python 3.12
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
RUN apt install -y \
    python3.12 \
    python3.12-venv \
    python3-pip

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mv noVNC-1.2.0 /noVNC
RUN rm v1.2.0.tar.gz

# VNC setup
RUN mkdir -p $HOME/.vnc
RUN echo "xt" | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

RUN echo '#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec dbus-launch --exit-with-session xfce4-session &' \
> $HOME/.vnc/xstartup
RUN chmod +x $HOME/.vnc/xstartup

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 6080
CMD ["/run.sh"]
