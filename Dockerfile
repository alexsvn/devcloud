#########
# Based on Debian
#########
FROM debian:latest

# -d
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y wget curl vim git python3 \
    wine qemu-kvm *zenhei* xz-utils dbus-x11 \
    firefox-esr gnome-system-monitor mate-system-monitor \
    xfce4 xfce4-terminal tightvncserver && \
    apt-get clean

# H5 VNC Client
RUN wget $(curl -s https://api.github.com/repos/novnc/noVNC/releases/latest | grep "tarball_url" | cut -d '"' -f 4) -O latest.tar.gz
RUN mkdir -p /opt/noVNC
RUN tar -xzf latest.tar.gz -C /opt/noVNC && rm latest.tar.gz

WORKDIR /opt/noVNC
COPY vnc.html /opt/noVNC/
COPY utils/websockify /opt/noVNC/utils/websockify

EXPOSE 6080
CMD ["./utils/launch.sh", "--vnc", "localhost:8787", "--listen", "6080"]
