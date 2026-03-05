#!/bin/bash

# Limpiar locks anteriores
rm -f /tmp/.X1-lock
rm -rf /tmp/.X11-unix

# Crear directorio X11
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Iniciar VNC como renderuser
su - renderuser -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no -fg" &

# Esperar a que VNC arranque
sleep 5

echo "==> VNC iniciado, arrancando noVNC en puerto 7681..."

# Iniciar noVNC
websockify --web=/usr/share/novnc/ 7681 localhost:5901
