# Based on https://github.com/frol/docker-alpine-python-machinelearning
FROM guitarmind/python-nginx
MAINTAINER markpeng@exosite.com

RUN apk update && \
    apk del llvm5-libs llvm5 llvm5-dev && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        g++ gfortran file binutils \
        musl-dev python3-dev cython openblas-dev \
        build-base freetype-dev libpng-dev \
        libffi-dev openssl-dev \
        cmake \
        && \

    apk add libstdc++ openblas \
        && \

    ln -s locale.h /usr/include/xlocale.h \
        && \

    # LLVM 7.0
    cd /tmp &&\
    wget http://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz && \
    tar xvf llvm-7.0.1.src.tar.xz && \
    cd /tmp/llvm-7.0.1.src && \
    ls -la && \
    mkdir build && \
    cd build && \
    cmake .. -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" \
        -DCMAKE_BUILD_TYPE=MinSizeRel && \
    make -j$(nproc) && \
    make install && \

    # Minimum required packages
    pip install Cython \
        numpy \
        pandas \
        scipy \
        && \

    # Dependency packages
    pip install scikit-learn \
        matplotlib \
        statsmodels \
        PyWavelets \
        llvmlite \
        librosa \
        && \

    # Model hosting related packages
    pip install flask \
        gevent \
        gunicorn \
        requests \
        && \

    # Cleanup
    rm -rf /var/cache/apk/* && \

    rm -r /root/.cache && \
    find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; \
        && \

    rm /usr/include/xlocale.h \
        && \
    apk del .build-dependencies
