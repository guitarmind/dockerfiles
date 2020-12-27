# Based on Miniconda Official Debian Dockerfile with Python 3.8
# https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
# 
# docker build --rm=true --no-cache=true -t guitarmind/miniconda -f ./Dockerfile .
# docker run --rm --name miniconda -it guitarmind/miniconda:py-3.8.5 bash
# 

FROM debian:buster-slim

LABEL MAINTAINER="Mark Peng"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# Disabling SSL verification
ENV SSL_NO_VERIFY=1

RUN apt-get update --fix-missing && \
    apt-get install -y \
        bzip2 \
        ca-certificates \
        git \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        mercurial \
        subversion \
        wget \
        # Extra
        vim \
        pigz \
        tzdata \
        htop \
        tmux \
    && apt-get clean

ENV PATH /opt/conda/bin:$PATH

CMD [ "/bin/bash" ]

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py38_4.9.2
ARG CONDA_MD5=122c8c9beb51e124ab32a0fa6426c656

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    echo "${CONDA_MD5}  miniconda.sh" > miniconda.md5 && \
    if ! md5sum --status -c miniconda.md5; then exit 1; fi && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh miniconda.md5 && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \

    echo "alias ll='ls -la'" >> ~/.bashrc && \

    # Conda Configuration
    mkdir -p /root/.conda/ && \
    echo 'ssl_verify: False \ndefault_threads: 4\n\
    ' >> /root/.conda/.condarc \
        && \

    # Tmux Setup
    echo 'set -g prefix C-a \nbind C-a send-prefix \nunbind C-b \n\
    ' >> /root/.tmux.conf


WORKDIR /workspace
