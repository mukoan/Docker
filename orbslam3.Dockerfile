FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
LABEL maintainer="Lyndon Hill <doryokuka@gmail.com>"

# Install core packages
RUN apt -qq update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
  bash-completion \
  build-essential \
  cmake \
  cmake-curses-gui \
  curl \
  ffmpeg \
  git \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-tools \
  less \
  make \
  nano \
  ninja-build \
  openexr \
  pkg-config \
  python3-pip \
  sudo \
  tar \
  tmux \
  unzip \
  vim \
  wget

# Install dev libraries
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  libboost-dev \
  libboost-all-dev \
  libeigen3-dev \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-good1.0-dev \
  libgstreamer-plugins-bad1.0-dev \
  libgstrtspserver-1.0-dev \
  libgstreamermm-1.0-dev \
  libgtk2.0-dev \
  libjpeg-dev \
  libopencv-dev \
  libopenexr-dev \
  libpng-dev \
  libprotobuf-dev protobuf-compiler \
  libssl-dev \
  libsuitesparse-dev \
  libtiff5-dev

# Add user
ENV USERNAME=user

RUN adduser --disabled-password --gecos '' $USERNAME && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo,video $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

USER user

# Build and install ORBSLAM3
COPY buildORBSLAM3.sh /home/user
COPY orbslam3.patch /home/user
WORKDIR /home/user
RUN /home/user/buildORBSLAM3.sh
