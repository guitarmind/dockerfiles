FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu20.04

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
    # python
    python3.8 python3-pip python3-setuptools python3-dev \
    # OpenCV deps
    libglib2.0-0 libsm6 libxext6 libxrender1 libgl1-mesa-glx \
    # c++
    g++ \
    # others
    wget unzip git vim tmux htop && \

    git clone https://github.com/TencentARC/GFPGAN.git && \
    cd GFPGAN && \

    # Ninja
    wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && \
    unzip ninja-linux.zip -d /usr/local/bin/ && \
    update-alternatives --install /usr/bin/ninja ninja /usr/local/bin/ninja 1 --force && \

    # basicsr facexlib
    python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir torch>=1.7 opencv-python>=4.5 && \
    pip3 install --no-cache-dir basicsr facexlib realesrgan && \

    # Weights
    wget https://github.com/TencentARC/GFPGAN/releases/download/v0.2.0/GFPGANCleanv1-NoCE-C2.pth \
        -P experiments/pretrained_models && \
    wget https://github.com/TencentARC/GFPGAN/releases/download/v0.1.0/GFPGANv1.pth \
        -P experiments/pretrained_models && \
    wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.1/RealESRGAN_x2plus.pth \
        -P /usr/local/lib/python3.8/dist-packages/realesrgan/weights && \
    wget https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth \
        -P /usr/local/lib/python3.8/dist-packages/facexlib/weights && \

    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean && \

    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install .

CMD ["python3", "inference_gfpgan.py", "--upscale", "2", "--test_path", "inputs/whole_imgs", "--save_root", "results"]
