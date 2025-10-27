FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
LABEL maintainer="Lyndon Hill <doryokuka@gmail.com>"

# Install essential packages and tools
RUN apt -qq update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git less libgl1 libglib2.0-0 ninja-build python3-dev python3-pip sudo tmux \
  unzip vim wget

# Clean cache and temporary files to reduce image size
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set permissions such that the output files can be accessed by the current user
RUN addgroup --gid 1000 user && \
    adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user && \
    usermod -aG sudo,video user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

USER user

# Install conda
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    sudo /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    /bin/bash -c "/opt/conda/bin/conda init bash"

# Add conda to path
ENV PATH=$CONDA_DIR/bin:$PATH

# Install PyTorch and TorchVision
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu118

# Install gsplat
RUN pip3 install gsplat

# We need the remainder to get the examples scripts and requirements list:

# Download gsplat source
RUN wget https://github.com/nerfstudio-project/gsplat/archive/refs/tags/v1.5.3.zip -O ~/gsplat.zip
RUN cd ~; unzip gsplat.zip; rm gsplat.zip

# Install dependencies
RUN cd ~/gsplat-1.5.3/examples; pip3 install -r requirements.txt
