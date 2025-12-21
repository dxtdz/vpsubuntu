#!/bin/bash

# Khởi động DBUS
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# Cấu hình mật khẩu VNC là "xt"
mkdir -p $HOME/.vnc
echo "xt" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Cấu hình khởi động XFCE
cat <<EOF > $HOME/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x $HOME/.vnc/xstartup

# Xóa các lock cũ để tránh lỗi khi restart trên Render
rm -rf /tmp/.X11-unix /tmp/.X*-lock
vncserver -kill :1 > /dev/null 2>&1

# Chạy VNC Server
vncserver :1 -geometry 1280x720 -depth 24

# Chạy noVNC trỏ vào port của VNC (5901)
# Render sẽ dùng biến $PORT, nếu không có mặc định là 8900
LISTEN_PORT=${PORT:-8900}
/noVNC-1.2.0/utils/launch.sh --vnc localhost:5901 --listen $LISTEN_PORT
