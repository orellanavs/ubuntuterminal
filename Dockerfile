FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=renderuser
ENV PASSWORD=render123

# Instalar todo lo necesario
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
    pulseaudio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario
RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:$PASSWORD" | chpasswd \
    && adduser $USER sudo \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurar VNC
RUN mkdir -p /home/$USER/.vnc
RUN echo "$PASSWORD" | vncpasswd -f > /home/$USER/.vnc/passwd \
    && chmod 600 /home/$USER/.vnc/passwd

# Script de inicio de VNC
RUN echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec startxfce4' > /home/$USER/.vnc/xstartup \
    && chmod +x /home/$USER/.vnc/xstartup

RUN chown -R $USER:$USER /home/$USER/.vnc

# Script principal de arranque
RUN echo '#!/bin/bash\n\
# Limpiar locks anteriores\n\
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1\n\
\n\
# Iniciar VNC como renderuser\n\
su - renderuser -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no"\n\
\n\
# Iniciar noVNC (expone el VNC via WebSocket en puerto 7681)\n\
websockify --web=/usr/share/novnc/ 7681 localhost:5901\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 7681

CMD ["/start.sh"]
