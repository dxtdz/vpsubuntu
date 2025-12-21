#!/bin/bash

# 1. Cấu hình các thư mục cần thiết
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# 2. Thiết lập mật khẩu VNC là "xt"
mkdir -p $HOME/.vnc
echo "xt" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# 3. Cấu hình giao diện XFCE4
cat <<EOF > $HOME/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4 &
EOF
chmod +x $HOME/.vnc/xstartup

# 4. Xóa lock file cũ (nếu container khởi động lại)
vncserver -kill :1 > /dev/null 2>&1
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# 5. Chạy VNC Server (Màn hình ảo số 1)
vncserver :1 -geometry 1280x720 -depth 24

# 6. Chạy noVNC
# Render sẽ cấp một biến $PORT, nếu không có sẽ mặc định là 8900
LISTEN_PORT=${PORT:-8900}
echo "Đang khởi động noVNC trên port $LISTEN_PORT..."
/noVNC-1.2.0/utils/launch.sh --vnc localhost:5901 --listen $LISTEN_PORT
