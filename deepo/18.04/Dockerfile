FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04

ENV CUDA_HOME=/usr/local/cuda

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    # Disabling SSL verification
    SSL_NO_VERIFY=1 \
    PYTHONDONTWRITEBYTECODE=true \
    PATH=/usr/local/cuda-11.0/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64:$LD_LIBRARY_PATH \
    TZ=Asia/Taipei

EXPOSE 8888 6006 8090

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python3.6 -m pip --no-cache-dir install --upgrade --default-timeout=100" && \
    GIT_CLONE="git clone --depth 10" && \
    TENSORRT_VERSION="7.1.3-1+cuda11.0" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \

    apt-get update --fix-missing && \

# ==================================================================
# System Packages & Tools
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
        ffmpeg \
        dbus \
        systemd \
        tzdata \
        python-tk \
        htop \
        tmux \
        unzip \
        python3.6 \
        python3-pip \
        python3-dev \
        python3-venv \
        python3-setuptools \
        && \

# ==================================================================
# CUDA Packages & Tools
# ------------------------------------------------------------------

    # TensorRT
    # Based on https://www.tensorflow.org/install/gpu#install_cuda_with_apt
    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
    apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
    apt-get update && \
    wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnvinfer7_7.1.3-1+cuda11.0_amd64.deb && \
    apt install ./libnvinfer7_7.1.3-1+cuda11.0_amd64.deb && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        libnvinfer7=$TENSORRT_VERSION \
        libnvinfer-dev=$TENSORRT_VERSION \
        libnvinfer-plugin7=$TENSORRT_VERSION \
        && \
    rm libnvinfer7_7.1.3-1+cuda11.0_amd64.deb && \

# ==================================================================
# Essesntial Packages
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update --fix-missing && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 20 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10 && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python ~/get-pip.py && \
    $PIP_INSTALL \
        pip \
        setuptools \
        future \
        protobuf \
        psutil \
        wheel \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas==0.25.3 \
        cloudpickle \
        scikit-learn \
        matplotlib \
        seaborn \
        Cython \
        && \

# ==================================================================
# Jupyter Notebook
# ------------------------------------------------------------------

    $PIP_INSTALL \
        yapf \
        jupyter \
        jupyter_contrib_nbextensions \
        jupyter_nbextensions_configurator \
        jedi==0.17.2 \
        parso==0.7.1 \
        nbconvert==5.6.1 \
        && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable code_prettify/code_prettify && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \

# ==================================================================
# Pytorch
# ------------------------------------------------------------------

    $PIP_INSTALL \
        torch==1.7.1+cu110 \
        torchvision==0.8.2+cu110 \
        torchaudio==0.7.2 \
        -f https://download.pytorch.org/whl/torch_stable.html \
        && \

    $PIP_INSTALL \
        torchlibrosa \
        efficientnet_pytorch \
        pytorch-lightning \
        pytorch-pfn-extras \
        pytorch-tabnet \
        torch_optimizer \
        && \

# ==================================================================
# Tensorflow
# ------------------------------------------------------------------

    $PIP_INSTALL \
        h5py \
        tensorflow==2.4.0 \
        tensorflow-determinism \
        tensorflow-addons \
        tensorboard==2.4.1 \
        && \

# ==================================================================
# OpenCV
# ------------------------------------------------------------------

    apt-get install -y \
        build-essential \
        cmake && \
    $GIT_CLONE --branch 4.4.0 https://github.com/opencv/opencv ~/opencv && \
    mkdir -p ~/opencv/build && cd ~/opencv/build && \
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/refs/tags/4.4.0.zip && \
    unzip opencv_contrib.zip && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=~/opencv/build/opencv_contrib-4.4.0/modules \
          -D WITH_IPP=OFF \
          -D WITH_CUDA=ON \
          -D OPENCV_DNN_CUDA=ON \
          -D WITH_OPENCL=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_opencv_python3=ON \
          -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python \
          -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/dist-packages/numpy/core/include \
          -D PYTHON3_LIBRARIES=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/libpython3.6.so \
          -D PYTHON3_INCLUDE_DIR=/usr/include/python3.6 \
          -D PYTHON3_EXECUTABLE=/usr/bin/python3.6 \
          -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.6/dist-packages \
          .. && \
    make -j"$(nproc)" install && \
    python -c "import cv2; print(cv2.__version__)" && \
    ln -s /usr/local/include/opencv4/opencv2 /usr/local/include/opencv2 && \

# ==================================================================
# Xgboost & LightGBM
# ------------------------------------------------------------------

    # Upgrade CMake
    apt-get remove -y --purge --auto-remove cmake && \
    mkdir /opt/cmake && \
    cd /opt/cmake && \
    wget https://github.com/Kitware/CMake/releases/download/v3.18.6/cmake-3.18.6-Linux-x86_64.sh && \
    sh ./cmake-3.18.6-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && \
    ln -s /opt/cmake/bin/cmake /usr/bin/cmake && \
    cmake --version && \

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        nvidia-opencl-dev opencl-headers \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libsndfile1 && \
    mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \

    # Xgboost
    $GIT_CLONE --branch v1.3.3 --recursive https://github.com/dmlc/xgboost ~/xgboost && \
    cd ~/xgboost && \
    mkdir build && \
    cd build && \
    cmake .. -DUSE_CUDA=ON \
        -DCMAKE_CUDA_COMPILER:PATH=/usr/local/cuda-11.0/bin/nvcc && \
    make -j$(nproc) && \
    cd .. && \
    cd python-package/ && \
    python setup.py install --use-cuda --use-nccl && \
    python -c "import xgboost as xgb; print(xgb.__version__)" && \
    cd .. && \

    # LightGBM
    $GIT_CLONE --branch v3.2.1 --recursive https://github.com/Microsoft/LightGBM ~/LightGBM && \
    cd ~/LightGBM && \
    mkdir build && \
    cd build && \
    cmake -DUSE_GPU=1 \
        -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so \
        -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. && \
    make -j$(nproc) && \
    cd .. && \
    cd python-package/ && \
    python setup.py install --precompile && \
    python -c "import lightgbm as lgb; print(lgb.__version__)" && \
    cd .. && \

# ==================================================================
# Darknet (YOLOv3, YOLOv4)
# ------------------------------------------------------------------
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH && \
    git clone https://github.com/AlexeyAB/darknet.git ~/darknet && \
    cd ~/darknet && \
    mkdir build_release && \
    cd build_release && \
    cmake .. -DCMAKE_PREFIX_PATH=~/opencv/build  && \
    cmake --build . --target install --parallel $(nproc) && \
    cp ./darknet /usr/local/bin/ && \
    cd .. && \

# ==================================================================
# MISC.
# ------------------------------------------------------------------

    $PIP_INSTALL \
        timm \
        effdet \
        geffnet \
        omegaconf \
        ensemble-boxes \
        pycocotools \
        'scikit-optimize[plots]' \
        featuretools \
        yellowbrick \
        imgaug \
        plotly \
        shap \
        albumentations \
        git+https://github.com/zhanghang1989/ResNeSt \
        git+https://github.com/dreamquark-ai/tabnet.git \
        transformers \
        nltk \
        spacy \
        scispacy \
        umap-learn \
        scikit-image \
        iterative-stratification \
        optuna \
        && \

    # To avoid AttributeError: module 'typing' has no attribute '_ClassVar'
    # pip uninstall -y dataclasses && \

# ==================================================================
# Config & Cleanup
# https://jcristharif.com/conda-docker-tips.html
# ------------------------------------------------------------------
    ldconfig && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

    find /usr/local/lib/python3.*/ -follow -type f -name '*.a' -delete && \
    find /usr/local/lib/python3.*/ -follow -type f -name '*.pyc' -delete && \
    find /usr/local/lib/python3.*/ -follow -type f -name '*.js.map' -delete && \
    find /usr/local/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/local/lib/python3.*/dist-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \

    apt-get remove -y build-essential cmake && \
    rm -rf /opt/cmake /usr/local/bin/cmake /usr/bin/cmake && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
