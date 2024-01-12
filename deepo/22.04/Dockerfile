FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

ENV CUDA_HOME=/usr/local/cuda

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    # Disabling SSL verification
    SSL_NO_VERIFY=1 \
    PYTHONDONTWRITEBYTECODE=true \
    PATH=/usr/local/cuda-11.7/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH \
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
        yapf==0.40.1 \
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
        torch==2.0.1+cu117 \
        torchvision==0.15.2+cu117 \
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
        pandas \
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
        jsonlines \
        submitit \
        termcolor \
        addict \
        supervision==0.6.0 \
        colorlog \
        pyyaml>3.10 \
        pycocotools \
        causal-conv1d==1.1.1 \
        mamba-ssm \
        && \

    $GIT_CLONE https://github.com/bowang-lab/U-Mamba && \
    cd U-Mamba/umamba && \
    pip install -e . && \

    python3 -c "import mamba_ssm; print(mamba_ssm.__version__)" \

    # $GIT_CLONE https://github.com/longzw1997/Open-GroundingDino.git && \
    # cd Open-GroundingDino/models/GroundingDINO/ops && \
    # python3 setup.py build install && \
    # python3 test.py && \
    # $GIT_CLONE https://github.com/IDEA-Research/GroundingDINO.git && \
    # cd GroundingDINO && \
    # pip install -e . && \
    # mkdir weights && \
    # cd weights && \
    # wget https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth && \
    # cd .. && \

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

