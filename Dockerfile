FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    wget \
    git \
    nano \
    htop \
    sudo \
    ttyd \
    && apt clean

RUN useradd -m ubuntu && echo "ubuntu:ubuntu" | chpasswd && adduser ubuntu sudo

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 8080

CMD ["ttyd", "-W", "-p", "8080", "bash"]
