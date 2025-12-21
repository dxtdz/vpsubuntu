FROM thuonghai2711/ubuntu-novnc-pulseaudio:22.04

# Cài đặt Chrome
RUN apt-get update && \
    apt-get remove -y firefox && \
    apt-get install -y wget && \
    wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y /tmp/chrome.deb && \
    rm -f /tmp/chrome.deb

# Cài đặt cloudflared
RUN wget -O /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# Cài đặt socat
RUN apt-get install -y socat

# Expose ports
EXPOSE 10000 5900 6900 1699

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
