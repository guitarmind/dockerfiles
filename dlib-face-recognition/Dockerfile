# This is a sample Dockerfile you can modify to deploy your own app based on face_recognition
# Modified version of https://github.com/ageitgey/face_recognition by Mark Peng

FROM python:3.4-slim

RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    software-properties-common \
    zip \
    libffi-dev \
    libssl-dev \
    libopenblas-dev \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.7' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS


# Install face_recognition dependencies and pre-trained models
RUN pip3 install face_recognition_models \
    Click \
    dlib \
    numpy \
    Pillow \
    scipy \
    face_recognition
