FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar todo
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
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
    firefox \
    fonts-dejavu \
    fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario
RUN useradd -m -s /bin/bash renderuser \
    && echo "renderuser:render123" | chpasswd \
    && adduser renderuser sudo \
    && echo "renderuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurar VNC
RUN mkdir -p /home/renderuser/.vnc \
    && echo "render123" | vncpasswd -f > /home/renderuser/.vnc/passwd \
    && chmod 600 /home/renderuser/.vnc/passwd

# Crear xstartup
RUN printf '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4\n' \
    > /home/renderuser/.vnc/xstartup \
    && chmod +x /home/renderuser/.vnc/xstartup \
    && chown -R renderuser:renderuser /home/renderuser/.vnc

# Crear script de inicio
RUN printf '#!/bin/bash\nrm -f /tmp/.X1-lock\nrm -rf /tmp/.X11-unix\nmkdir -p /tmp/.X11-unix\nchmod 1777 /tmp/.X11-unix\nsu - renderuser -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no -fg" &\nsleep 5\necho "VNC listo, iniciando noVNC..."\nwebsockify --web=/usr/share/novnc/ 7681 localhost:5901\n' \
    > /start.sh \
    && chmod +x /start.sh

EXPOSE 7681

CMD ["/start.sh"]
