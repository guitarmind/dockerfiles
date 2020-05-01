# ==================================================================
# module list
# ------------------------------------------------------------------
# python        3.6    (apt)
# jupyter       latest (pip)
# pytorch       latest (pip)
# tensorflow    latest (pip)
# keras         latest (pip)
# mxnet         latest (pip)
# gluonts       latest (pip)
# opencv        4.0.1  (git)
# ==================================================================

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
    TENSORRT_VERSION="6.0.1-1+cuda10.1" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \

    apt-get update --fix-missing && \

# ==================================================================
# tools
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        cmake \
        wget \
        git \
        vim \
        pigz \
        && \

# ==================================================================
# python
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        python3-distutils-extra \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        # numpy==1.14.* \
        numpy==1.17.* \
        scipy \
        pandas \
        cloudpickle \
        scikit-learn \
        matplotlib \
        Cython \
        && \

# ==================================================================
# boost
# ------------------------------------------------------------------

    wget -O ~/boost.tar.gz https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz && \
    tar -zxf ~/boost.tar.gz -C ~ && \
    cd ~/boost_* && \
    ./bootstrap.sh --with-python=python3.6 && \
    ./b2 install --prefix=/usr/local && \

# ==================================================================
# jupyter
# ------------------------------------------------------------------

    $PIP_INSTALL \
        jupyter \
        tornado==5.1.1 \
        yapf \
        jupyter_contrib_nbextensions \
        && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable code_prettify/code_prettify && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \

# ==================================================================
# pytorch
# ------------------------------------------------------------------

    # Python 3.6, CUDA 10.1
    # $PIP_INSTALL \
    #     https://download.pytorch.org/whl/cu101/torch-1.1.0-cp36-cp36m-linux_x86_64.whl \
    #     && \
    # $PIP_INSTALL \
    #     https://download.pytorch.org/whl/cu101/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl \
    #     && \
    $PIP_INSTALL \
        torch==1.4.0 \
        && \

    $PIP_INSTALL \
        future \
        protobuf \
        enum34 \
        pyyaml \
        typing \
        && \

# ==================================================================
# mxnet
# ------------------------------------------------------------------

    # CUDA 10.0 (CUDA/cuDNN and MKL-DNN enabled)
    # $PIP_INSTALL \
    #     "mxnet-cu100mkl>=1.3.1,<1.5.*" \
    #     gluonts \
    #     && \

# ==================================================================
# tensorflow
# ------------------------------------------------------------------

    $PIP_INSTALL \
        h5py \
        tensorflow-gpu==2.1.0-rc0 \
        tensorflow-determinism \
        tensorflow-addons \
        tensorboard \
        && \

# ==================================================================
# keras
# ------------------------------------------------------------------

    # $PIP_INSTALL \
    #     h5py \
    #     keras==2.2.4 \
    #     && \

# ==================================================================
# opencv
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        libatlas-base-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        && \

    $GIT_CLONE --branch 4.0.1 https://github.com/opencv/opencv ~/opencv && \
    mkdir -p ~/opencv/build && cd ~/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_IPP=OFF \
          -D WITH_CUDA=OFF \
          -D WITH_OPENCL=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          .. && \
    make -j"$(nproc)" install && \
    ln -s /usr/local/include/opencv4/opencv2 /usr/local/include/opencv2 && \

# ==================================================================
# markpeng
# ------------------------------------------------------------------

    # Upgrade CMake
    apt-get remove -y --purge --auto-remove cmake && \
    mkdir /opt/cmake && \
    cd /opt/cmake && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3-Linux-x86_64.sh && \
    sh ./cmake-3.14.3-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && \
    ln -s /opt/cmake/bin/cmake /usr/bin/cmake && \
    cmake --version && \
    
    $PIP_INSTALL \
        pip \
        psutil \
        seaborn \
        bayesian-optimization \
        numba \
        pyarrow==0.11 \
        joblib \
        PyWavelets \
        statsmodels \
        plotly \
        librosa==0.6.3 \
        tqdm \
        git+https://github.com/huggingface/transformers#master \
        # transformers==2.7.0 \
        tensorflow-determinism \
        langdetect \
        beautifulsoup4 \
        && \

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        nvidia-opencl-dev opencl-headers \
        git \
        build-essential \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        python-setuptools && \
    mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \

    # LightGBM
    $GIT_CLONE --recursive https://github.com/Microsoft/LightGBM ~/LightGBM && \
    cd ~/LightGBM && \
    mkdir build && \
    cd build && \
    cmake -DUSE_GPU=1 .. && \
    make -j$(nproc) && \
    cd .. && \
    cd python-package/ && \
    python setup.py install --precompile && \
    cd .. && \

    # Xgboost
    $GIT_CLONE --recursive https://github.com/dmlc/xgboost ~/xgboost && \
    cd ~/xgboost && \
    mkdir build && \
    cd build && \
    cmake .. -DUSE_CUDA=ON && \
    make -j$(nproc) && \
    cd .. && \
    cd python-package/ && \
    python setup.py install && \
    cd .. && \

    # Apex
    $GIT_CLONE --recursive https://github.com/NVIDIA/apex ~/apex && \
    cd ~/apex && \
    $PIP_INSTALL -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./ && \
    cd .. && \

    # TensorRT
    # Based on https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html
    wget -O tensorrt.deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
    dpkg -i tensorrt.deb && \
    apt-get update && \
    $PIP_INSTALL \
        libnvinfer6=$TENSORRT_VERSION \
        libnvonnxparsers6=$TENSORRT_VERSION \
        libnvparsers6=$TENSORRT_VERSION \
        libnvinfer-plugin6=$TENSORRT_VERSION \
        libnvinfer-dev=$TENSORRT_VERSION \
        libnvonnxparsers-dev=$TENSORRT_VERSION \
        libnvparsers-dev=$TENSORRT_VERSION \
        libnvinfer-plugin-dev=$TENSORRT_VERSION \
        python3-libnvinfer=$TENSORRT_VERSION \
        python3-libnvinfer-dev=$TENSORRT_VERSION \
        uff-converter-tf=$TENSORRT_VERSION && \
    # Note: need to unhold for new update later
    apt-mark hold \
        libnvinfer6 \
        libnvonnxparsers6 \
        libnvparsers6 \
        libnvinfer-plugin6 \
        libnvinfer-dev \
        libnvonnxparsers-dev \
        libnvparsers-dev \
        libnvinfer-plugin-dev \
        python3-libnvinfer \
        python3-libnvinfer-dev \
        uff-converter-tf && \
    dpkg -l | grep TensorRT && \
    rm tensorrt.deb && \

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------

    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

EXPOSE 8888 6006
