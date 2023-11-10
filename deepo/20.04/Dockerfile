# FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu20.04
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
# FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

ENV CUDA_HOME=/usr/local/cuda

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    # Disabling SSL verification
    SSL_NO_VERIFY=1 \
    PYTHONDONTWRITEBYTECODE=true \
    PATH=/usr/local/cuda-11.3/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.3/lib64:$LD_LIBRARY_PATH \
    TZ=Asia/Taipei \
    APT_INSTALL="apt-get install -y --no-install-recommends" \
    PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade --default-timeout=100" \
    GIT_CLONE="git clone --depth 10"

EXPOSE 8888 6006 8090

RUN apt-get update --fix-missing && \

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
        python3-pip \
        python3-dev \
        python3-venv \
        python3-setuptools \
        python3-pybind11 \
        libblas-dev \
        liblapack-dev \
        libjpeg-dev \
        zlib1g-dev \
        libffi-dev \
        python3-gi \
        nginx \
        && \

# ==================================================================
# Jupyter Notebook
# ------------------------------------------------------------------

    $PIP_INSTALL \
        traitlets==5.9.0 \
        jsonschema'[format]' \
        notebook==6.4.12 \
        jupyter \
        jupyter_contrib_nbextensions \
        jupyter_nbextensions_configurator \
        && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable code_prettify/code_prettify && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable toggle_all_line_numbers/main && \

# ==================================================================
# Pytorch
# ------------------------------------------------------------------

    $PIP_INSTALL \
        torch==1.12.1+cu113 \
        torchvision==0.13.1+cu113 \
        -f https://download.pytorch.org/whl/torch_stable.html \
        && \
    python3 -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')" \
        && \

    $PIP_INSTALL \
        torchmetrics==0.11.0 \
        pytorch-lightning==1.8.6 \
        torch_optimizer \
        torchinfo \
        && \
    python3 -c "import pytorch_lightning as pl; print(pl.__version__)" \

    && \

# ==================================================================
# MISC.
# ------------------------------------------------------------------

    $PIP_INSTALL \
        numpy \
        scipy \
        pandas==0.25.3 \
        scikit-learn \
        matplotlib \
        seaborn \
        transformers \
        accelerate \
        tiktoken \
        einops \
        pillow \
        tensorboard \
        timm \
        albumentations \
        gradio \
        markupsafe==2.0.1 \
        && \

    python3 -c "import cv2; print(cv2.__version__)" \

    && \

# ==================================================================
# GroundingDINO
# ------------------------------------------------------------------

    $PIP_INSTALL \
        submitit \
        termcolor \
        addict \
        supervision==0.6.0 \
        colorlog \
        pyyaml>3.10 \
        pycocotools \
        && \
    $GIT_CLONE https://github.com/longzw1997/Open-GroundingDino.git && \
    cd Open-GroundingDino/models/GroundingDINO/ops && \
    python3 setup.py build install && \
    python3 test.py && \

    echo "\
unbind C-b\n\
set-option -g prefix C-a\n\
bind-key C-a send-prefix\n\
" > /root/.tmux.conf && \

# ==================================================================
# Config & Cleanup
# https://jcristharif.com/conda-docker-tips.html
# ------------------------------------------------------------------
    ldconfig && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

    # Clean up
    find /usr/local/lib/python3.*/ -follow -type f -name '*.a' -delete && \
    find /usr/local/lib/python3.*/ -follow -type f -name '*.pyc' -delete && \
    find /usr/local/lib/python3.*/ -follow -type f -name '*.js.map' -delete && \
    find /usr/local/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/local/lib/python3.*/dist-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \

    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

