FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1280x720x24

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    sudo \
    curl \
    wget \
    git \
    nano \
    htop \
    neofetch \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario
RUN useradd -m -s /bin/bash renderuser \
    && echo "renderuser:render123" | chpasswd \
    && adduser renderuser sudo \
    && echo "renderuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Script de inicio
RUN printf '#!/bin/bash\n\
set -e\n\
\n\
echo "==> Iniciando Xvfb..."\n\
Xvfb :1 -screen 0 1280x720x24 &\n\
sleep 2\n\
\n\
echo "==> Iniciando XFCE..."\n\
export DISPLAY=:1\n\
su - renderuser -c "DISPLAY=:1 startxfce4 &"\n\
sleep 3\n\
\n\
echo "==> Iniciando x11vnc..."\n\
x11vnc -display :1 -nopw -listen localhost -xkb -forever -shared &\n\
sleep 2\n\
\n\
echo "==> Iniciando noVNC en puerto 7681..."\n\
websockify --web=/usr/share/novnc/ 7681 localhost:5900\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 7681

CMD ["/start.sh"]
