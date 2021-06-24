FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

ENV CUDA_HOME=/usr/local/cuda

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    # Disabling SSL verification
    SSL_NO_VERIFY=1 \
    PATH=/opt/conda/bin:$PATH \
    PYTHONDONTWRITEBYTECODE=true \
    TZ=Asia/Taipei \
    PYTHONPATH="${PYTHONPATH}:/opt/conda/lib/python3.7/site-packages:/opt/conda/lib/python3.7:/opt/conda/lib"

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
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python ~/get-pip.py && \
    $PIP_INSTALL \
        setuptools \
        future \
        protobuf \
        psutil \
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
        torch==1.7.1+cu101 \
        torchvision==0.8.2+cu101 \
        torchaudio==0.7.0 \
        -f https://download.pytorch.org/whl/torch_stable.html \
        && \

    $PIP_INSTALL \
        torchlibrosa \
        efficientnet_pytorch \
        torch-optimizer \
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
        tensorboard \
        && \

# ==================================================================
# OpenCV
# ------------------------------------------------------------------

    apt-get install -y \
        build-essential \
        cmake && \
    ln -s /opt/conda/lib/python3.8/site-packages/numpy/core/include/numpy /usr/include/numpy && \
    $GIT_CLONE --branch 4.3.0 https://github.com/opencv/opencv ~/opencv && \
    mkdir -p ~/opencv/build && cd ~/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/opt/conda \
          -D WITH_IPP=OFF \
          -D WITH_CUDA=OFF \
          -D WITH_OPENCL=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_opencv_python3=ON \
          -D PYTHON_DEFAULT_EXECUTABLE=/opt/conda/bin/python \
          -D PYTHON3_NUMPY_INCLUDE_DIRS=/opt/conda/lib/python3.8/site-packages/numpy/core/include \
          -D PYTHON3_LIBRARIES=/opt/conda/lib/libpython3.8.so \
          -D PYTHON3_INCLUDE_DIR=/opt/conda/include/python3.8 \
          -D PYTHON3_EXECUTABLE=/opt/conda/bin/python \
          -D PYTHON3_PACKAGES_PATH=/opt/conda/lib/python3.8/site-packages \
          .. && \
    make -j"$(nproc)" install && \
    python -c "import cv2; print(cv2.__version__)" && \
    apt-get remove -y build-essential cmake && \

# ==================================================================
# Xgboost & LightGBM
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

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        nvidia-opencl-dev opencl-headers \
        git \
        build-essential \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libsndfile1 \
        python-setuptools && \
    mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \

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

# ==================================================================
# Darknet (YOLOv3, YOLOv4)
# ------------------------------------------------------------------
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH && \
    git clone https://github.com/AlexeyAB/darknet.git ~/darknet && \
    cd ~/darknet && \
    # cmake
    sh ./build.sh && \
    # make
    # sed -i s/GPU=0/GPU=1/g Makefile && \
    # sed -i s/CUDNN=0/CUDNN=1/g Makefile && \
    # sed -i s/CUDNN_HALF=0/CUDNN_HALF=1/g Makefile && \
    # sed -i s/OPENCV=0/OPENCV=1/g Makefile && \
    # sed -i s/AVX=0/AVX=1/g Makefile && \
    # sed -i s/OPENMP=0/OPENMP=1/g Makefile && \
    # sed -i s/LIBSO=0/LIBSO=1/g Makefile && \
    # make -j 2 && \
    cp ./darknet /usr/local/bin/ && \
    # cp libdark.so libdarknet.so && \
    # chmod a+x libdarknet.so && \
    cd .. && \

# ==================================================================
# MISC.
# ------------------------------------------------------------------

    $PIP_INSTALL \
        timm \
        effdet \
        omegaconf \
        ensemble-boxes \
        pycocotools \
        'scikit-optimize[plots]' \
        geffnet \
        featuretools \
        yellowbrick \
        mlflow \
        imgaug \
        plotly \
        shap \
        albumentations \
        git+https://github.com/zhanghang1989/ResNeSt \
        git+https://github.com/dreamquark-ai/tabnet.git \
        transformers==4.5.0 \
        nltk \
        textblob \
        # Scpacy
        spacy \
        scispacy \
        umap-learn \
        gym \
        scikit-image \
        iterative-stratification \
        kiwisolver==1.0.1 \
        optuna && \

    # To avoid AttributeError: module 'typing' has no attribute '_ClassVar'
    pip uninstall -y dataclasses && \

# ==================================================================
# Config & Cleanup
# https://jcristharif.com/conda-docker-tips.html
# ------------------------------------------------------------------
    ldconfig && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.pyc' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    find /opt/conda/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /opt/conda/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \

    apt-get remove -y binutils && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    conda clean --all -y && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
