FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    ttyd \
    sudo \
    curl \
    wget \
    git \
    nano \
    htop \
    neofetch

RUN useradd -m renderuser && echo "renderuser:render" | chpasswd && adduser renderuser sudo

EXPOSE 7681

CMD ["ttyd", "-W", "-p", "7681", "bash"]
