FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt upgrade -y && \
    apt install -y xfce4 xfce4-goodies xrdp novnc websockify pulseaudio dbus-x11 \
    x11-xserver-utils curl wget git unzip && \
    mkdir -p /opt/novnc && \
    cd /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify.git && \
    cd noVNC && \
    ln -s ../websockify websockify && \
    chmod +x /opt/novnc/noVNC/utils/launch.sh

# Tambahkan skrip startup
COPY start.sh /opt/novnc/start-novnc.sh
RUN chmod +x /opt/novnc/start-novnc.sh

# Konfigurasi XRDP
RUN systemctl enable xrdp && systemctl start xrdp

# Setel wallpaper anime
RUN mkdir -p /usr/share/backgrounds && \
    wget -O /usr/share/backgrounds/anime_wallpaper.jpg \
    "https://c4.wallpaperflare.com/wallpaper/702/677/218/anime-anime-girls-sword-red-fan-art-hd-wallpaper-preview.jpg"

# Instal tema ikon Windows 10
RUN mkdir -p ~/.icons && \
    cd ~/.icons && \
    git clone https://github.com/B00merang-Artwork/Windows-10.git

# Jalankan NoVNC saat container berjalan
CMD ["/opt/novnc/start-novnc.sh"]
