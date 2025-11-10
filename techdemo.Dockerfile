FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
LABEL maintainer="Lyndon Hill <doryokuka@gmail.com>"

# Install packages
RUN apt -qq update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
  bash-completion \
  build-essential \
  cmake \
  cmake-curses-gui \
  curl \
  ffmpeg \
  git \
  less \
  libopencv-dev \
  make \
  ninja-build \
  pkg-config \
  python3-pip python3-dev python3-numpy python3-distutils \
  python3-setuptools python3-pyqt5 \
  sudo \
  tar \
  unzip \
  vim \
  wget

# Clean cache and temporary files to reduce image size
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Add user
ENV USERNAME=user

RUN adduser --disabled-password --gecos '' $USERNAME && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo,video $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER user

WORKDIR /home/user

# Install additional Python packages
RUN pip3 install matplotlib
RUN pip3 install opencv-python
RUN pip3 install opencv-contrib-python

# Install PyTorch
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu118
