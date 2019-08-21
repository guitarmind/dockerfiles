# Based on https://github.com/frol/docker-alpine-python-machinelearning
# FROM guitarmind/python-nginx
# FROM guitarmind/python-ml
FROM pump-dl-dev
MAINTAINER markpeng@exosite.com

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
    BAZEL_VERSION=0.15.0 \
    TENSORFLOW_VERSION=1.12.0 \
    LOCAL_RESOURCES=2048,4,1.0

RUN apk update && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        g++ gfortran file binutils \
        musl-dev python3-dev cython openblas-dev \
        build-base freetype-dev libpng-dev \
        libffi-dev openssl-dev \
        llvm-dev \
        bash zip \
        openjdk8 \
        patch \
        libexecinfo-dev \
        && \

    apk add libstdc++ openblas \
        && \

    ln -s locale.h /usr/include/xlocale.h \
        && \

    # llvm - https://github.com/ziglang/docker-zig/blob/master/Dockerfile
    # WORKDIR /deps
    # RUN wget http://releases.llvm.org/8.0.0/llvm-8.0.0.src.tar.xz
    # RUN tar xf llvm-8.0.0.src.tar.xz
    # RUN mkdir -p /deps/llvm-8.0.0.src/build
    # WORKDIR /deps/llvm-8.0.0.src/build
    # RUN cmake .. -DCMAKE_INSTALL_PREFIX=/deps/local -DCMAKE_PREFIX_PATH=/deps/local -DCMAKE_BUILD_TYPE=Release -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="AVR;RISCV" -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_TERMINFO=OFF
    # RUN make $MAKE_JOBS install

    # Bazel download and install
    # cd /tmp && \
    # wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip && \
    # mkdir bazel-${BAZEL_VERSION} && \
    # unzip -qd bazel-${BAZEL_VERSION} bazel-${BAZEL_VERSION}-dist.zip && \
    # cd /tmp/bazel-${BAZEL_VERSION} && \
    # sed -i -e 's/-classpath/-J-Xmx8192m -J-Xms128m -classpath/g' scripts/bootstrap/compile.sh && \
    # bash compile.sh && \
    # cp -p output/bazel /usr/bin/ && \

    # Tensorflow with Intel MKL-DNN for AWS EC2 M5 instnace with Xeon Skylake SP processor (support AVX-512)
    cd /tmp && \
    wget -O tensorflow-${TENSORFLOW_VERSION}.tar.gz https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_VERSION}.tar.gz && \
    tar xzf tensorflow-${TENSORFLOW_VERSION}.tar.gz && \
    cd /tmp/tensorflow-${TENSORFLOW_VERSION} && \
    TF_NEED_JEMALLOC=1 \
    TF_NEED_IGNITE=0 \
    TF_NEED_GCP=0 \
    TF_NEED_HDFS=0 \
    TF_NEED_S3=0 \
    TF_ENABLE_XLA=0 \
    TF_NEED_GDR=0 \
    TF_NEED_VERBS=0 \
    TF_NEED_OPENCL=0 \
    TF_NEED_CUDA=0 \
    TF_NEED_MPI=0 \
    ./configure && \
    bazel build --config=mkl --config=opt \
        --copt=-march="native" \
        # --copt=-march="skylake-avx512" \
        --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
        --local_resources=${LOCAL_RESOURCES} \
        --verbose_failures \
        //tensorflow/tools/pip_package:build_pip_package && \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkgs && \

    # Cleanup
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \

    # rm -r /root/.cache && \
    find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; \
        && \

    rm /usr/include/xlocale.h \
        && \
    apk del .build-dependencies
