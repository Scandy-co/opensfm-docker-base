FROM ubuntu:14.04


# Install apt-getable dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        git \
        libatlas-base-dev \
        libboost-python-dev \
        libeigen3-dev \
        libgoogle-glog-dev \
        libopencv-dev \
        libsuitesparse-dev \
        python-dev \
        python-numpy \
        python-opencv \
        python-pip \
        python-pyexiv2 \
        python-pyproj \
        python-scipy \
        python-yaml \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get the latest CMake version
RUN \
     version=3.9.6 \
  && mkdir ~/temp \
  && cd ~/temp \
  && wget https://cmake.org/files/v3.9/cmake-$version.tar.gz \
  && tar -xzvf cmake-$version.tar.gz \
  && cd cmake-$version/ \
  && ./bootstrap \
  && make -j4 \
  && make install

# Install Ceres from source
RUN \
    mkdir -p /source && cd /source && \
    wget http://ceres-solver.org/ceres-solver-1.10.0.tar.gz && \
    tar xvzf ceres-solver-1.10.0.tar.gz && \
    cd /source/ceres-solver-1.10.0 && \
    mkdir -p build && cd build && \
    cmake .. -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF && \
    make install && \
    cd / && \
    rm -rf /source/ceres-solver-1.10.0 && \
    rm -f /source/ceres-solver-1.10.0.tar.gz


# Install opengv from source
RUN \
    mkdir -p /source && cd /source && \
    git clone https://github.com/Scandy-co/opengv.git && \
    cd /source/opengv && \
    mkdir -p build && cd build && \
    cmake .. -DBUILD_TESTS=OFF -DBUILD_PYTHON=ON && \
    make -j4 install && \
    cd / && \
    rm -rf /source/opengv

# Build OpenSFM
RUN \
    mkdir -p /source && cd /source && \
    git clone https://github.com/Scandy-co/opensfm.git && \
    cd /source/opensfm \
    && pip install -r requirements.txt \
    && python setup.py build
