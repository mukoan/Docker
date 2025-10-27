FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
LABEL maintainer="Lyndon Hill <doryokuka@gmail.com>"

ARG OPENCV_VERSION="4.12.0"

# Install core packages
RUN apt -qq update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
  bash-completion \
  build-essential \
  cmake \
  cmake-curses-gui \
  curl \
  ffmpeg \
  gdb \
  git \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-tools \
  less \
  make \
  ninja-build \
  openexr \
  pkg-config \
  python3-pip python3-dev python3-numpy python3-distutils \
  python3-setuptools python3-pyqt5 \
  sudo \
  tar \
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
  libgstrtspserver-1.0-dev \
  libgstreamermm-1.0-dev \
  libgtk2.0-dev \
  libjpeg-dev \
  libopenexr-dev \
  libpng-dev \
  libsuitesparse-dev \
  libtiff5-dev

# Clean cache and temporary files to reduce image size
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Build OpenCV in Docker
WORKDIR /tmp
RUN wget -O cv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && wget -O contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
    && unzip cv.zip \
    && unzip contrib.zip \
    && mv opencv-${OPENCV_VERSION} opencv \
    && mv opencv_contrib-${OPENCV_VERSION} opencv_contrib

RUN mkdir opencv/build
WORKDIR /tmp/opencv/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
 -D CMAKE_INSTALL_PREFIX=/usr/local \
 -D OPENCV_GENERATE_PKGCONFIG=ON \
 -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules \
 -D WITH_CUDA=ON \
 -GNinja \
 .. \
    && ninja && ninja install && ldconfig

WORKDIR /tmp
RUN rm -rf opencv cv.zip contrib.zip

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
RUN pip3 install opencv-python==4.12.0.88
RUN pip3 install opencv-contrib-python==4.12.0.88

# Install PyTorch
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu118
