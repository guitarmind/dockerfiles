FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu20.04

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
    # python
    python3.8 python3-pip python3-setuptools python3-dev \
    # OpenCV deps
    libglib2.0-0 libsm6 libxext6 libxrender1 libgl1-mesa-glx \
    cmake libgl1-mesa-dev \
    # c++
    g++ \
    # others
    wget unzip git vim tmux htop && \

    git clone https://github.com/chaofengc/PSFR-GAN.git && \
    cd PSFR-GAN && \

    python3 -m pip install --upgrade pip && \
    pip3 install gdown && \
    pip3 install \
        torch==1.5.1 \
        torchvision==0.6.1 \
        tensorflow==2.5.2 \
        tensorboardX==2.1 \
        opencv-python \
        dlib \
        scikit-image==0.17.2 \
        scipy==1.4.1 \
        tqdm \
        imgaug && \

    # Weights
    gdown https://drive.google.com/drive/folders/1Ubejhxd2xd4fxGc_M_LWl3Ux6CgQd9rP \
        -O ./pretrain_models --folder && \
    
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean && \

CMD ["python3", "test_enhance_single_unalign.py", "--test_img_path ", \
     "./test_dir/test_hzgg.jpg", "--results_dir", "test_hzgg_results", "--gpus", "-1"]
