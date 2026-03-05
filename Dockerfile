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

# Configurar VNC password
RUN mkdir -p /home/renderuser/.vnc \
    && echo "render123" | vncpasswd -f > /home/renderuser/.vnc/passwd \
    && chmod 600 /home/renderuser/.vnc/passwd

# Script xstartup para XFCE
COPY xstartup /home/renderuser/.vnc/xstartup
RUN chmod +x /home/renderuser/.vnc/xstartup \
    && chown -R renderuser:renderuser /home/renderuser/.vnc

# Script principal
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 7681

CMD ["/start.sh"]
