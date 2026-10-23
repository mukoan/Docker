#!/bin/bash
# File  : buildORBSLAM3.sh
# Brief : Build ORBSLAM3
# Author: Lyndon Hill
# Date  : 2026.09.25

# Get Pangolin
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
# Edit the install script to not require keyboard input
sed -i "s/install --no-install-suggests/install -y --no-install-suggests/" scripts/install_prerequisites.sh
./scripts/install_prerequisites.sh -m apt recommended
# Build and install Pangolin
cmake -B build -GNinja
cmake --build build
cd build; sudo cmake --build . --target install

# Get ORBSLAM3
cd ~
git clone https://github.com/jeremysalwen/ORB_SLAM_COMMUNITY.git
cd ORB_SLAM_COMMUNITY

# Patch to support export of sparse point cloud and COLMAP output
git apply ../orbslam3.patch

# Build ORBSLAM3
./build.sh
