# Include pre-built tensorflow image from Ubuntu 18.04
# Command: docker build --rm=true --no-cache=true -t python-dl:devel-tensorflow --file=Dockerfile.devel-tensorflow .
# FROM guitarmind/python-dl:ubuntu-devel-tensorflow as build_image
# FROM python-dl:ubuntu-devel-tensorflow as build_image

# Based on https://github.com/frol/docker-alpine-python-machinelearning
FROM guitarmind/python-nginx
MAINTAINER markpeng@exosite.com

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
    BAZEL_VERSION=0.15.0 \
    TENSORFLOW_VERSION=1.12.0

# Copy tensorflow wheel
COPY --from=build_image /root/tensorflow-${TENSORFLOW_VERSION}-cp36-cp36m-linux_x86_64.whl /tmp/

# Install MKL libraries
# COPY --from=build_image /usr/local/lib/libiomp5.so /usr/local/lib
# COPY --from=build_image /usr/local/lib/libmklml_gnu.so /usr/local/lib
# COPY --from=build_image /usr/local/lib/libmklml_intel.so /usr/local/lib
COPY --from=build_image /usr/local/lib/python3.6/dist-packages/_solib_k8/_U@mkl_Ulinux_S_S_Cmkl_Ulibs_Ulinux___Uexternal_Smkl_Ulinux_Slib/libiomp5.so /usr/local/lib
# COPY --from=build_image /usr/local/lib/python3.6/dist-packages/_solib_k8/_U@mkl_Ulinux_S_S_Cmkl_Ulibs_Ulinux___Uexternal_Smkl_Ulinux_Slib/libmklml_gnu.so /usr/local/lib
COPY --from=build_image /usr/local/lib/python3.6/dist-packages/_solib_k8/_U@mkl_Ulinux_S_S_Cmkl_Ulibs_Ulinux___Uexternal_Smkl_Ulinux_Slib/libmklml_intel.so /usr/local/lib

ENV LIBRARY_PATH="/usr/local/lib:$LIBRARY_PATH" \
    LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
# ENV LIBRARY_PATH="/usr/local/lib:/lib64/:$LIBRARY_PATH" \
#     LD_LIBRARY_PATH="/usr/local/lib:/lib64/:$LD_LIBRARY_PATH"

RUN apk update && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        g++ gfortran file binutils \
        musl-dev python3-dev cython openblas-dev \
        build-base freetype-dev libpng-dev \
        libffi-dev openssl-dev \
        # libc6-compat \
        llvm-dev \
        && \

    apk add --no-cache libstdc++ openblas \
        # libc6-compat \
        && \

    # glibc on alpine
    # https://github.com/sgerrand/alpine-pkg-glibc
    cd /tmp && \
    apk --no-cache add ca-certificates && \
    wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    apk add glibc-2.30-r0.apk && \

    ln -s locale.h /usr/include/xlocale.h \
        && \

    pip --no-cache-dir install --upgrade \
        pip \
        setuptools && \

    # Minimum required packages
    # pip install Cython \
    #     # https://github.com/tensorflow/tensorflow/issues/30427
    #     numpy==1.16.4 \
    #     pandas \
    #     scipy \
    #     && \

    # Install tensorflow and keras
    cd /tmp && \
    apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        hdf5 \
        hdf5-dev && \
    pip3 install --no-cache-dir \
        /tmp/tensorflow-${TENSORFLOW_VERSION}-cp36-cp36m-linux_x86_64.whl && \
        # pip3 install keras==2.2.4 && \
        python3 -c 'import tensorflow as tf; print("Tensorflow version: {}".format(tf.__version__)); print("Is MKL enabled?{}".format(tf.pywrap_tensorflow.IsMklEnabled()))' && \

    # Dependency packages
    # pip install scikit-learn \
    #     matplotlib \
    #     statsmodels \
    #     PyWavelets \
    #     # Need LLVM >= 7.0
    #     librosa \
    #     && \

    # Model hosting related packages
    # pip install flask \
    #     gevent \
    #     gunicorn \
    #     requests \
    #     && \

    # Cleanup
    # rm -rf /var/cache/apk/* && \
    # rm -rf /tmp/* && \

    # rm -r /root/.cache && \
    # find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    # find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; \
    #     && \

    # rm /usr/include/xlocale.h \
    #     && \
    # apk del .build-dependencies
