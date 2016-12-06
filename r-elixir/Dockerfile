FROM r-base:3.3.0
MAINTAINER markpeng@exosite.com

RUN apt-get update && apt-get install -y openssh-server libcurl4-openssl-dev libssl-dev libxml2-dev curl autoconf

# install required R dependencies and setup R packages
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile && \
    Rscript -e "install.packages('Rserve')" && \
    Rscript -e "install.packages('fpp')" && \
    Rscript -e "install.packages('devtools')" && \
    Rscript -e "devtools::install_github('twitter/AnomalyDetection')"

# install elixir dependencies
ENV OTP_VERSION="18.3.4.4"

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
    && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
    && OTP_DOWNLOAD_SHA256="3956f5c4fcd05848c7fe048d5c4ef7eaf002a8312cba0674150c5a10ab0e9f04" \
    && runtimeDeps='libodbc1 \
            libsctp1' \
    && buildDeps='unixodbc-dev \
            libsctp-dev' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $runtimeDeps \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
    && echo "$OTP_DOWNLOAD_SHA256 otp-src.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/otp-src \
    && tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure --enable-sctp \
    && make -j$(nproc) \
    && make install \
    && find /usr/local -name examples | xargs rm -rf \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /usr/src/otp-src /var/lib/apt/lists/*

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.3.4" \
    LANG=C.UTF-8

RUN set -xe \
    && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip" \
    && ELIXIR_DOWNLOAD_SHA256="eac16c41b88e7293a31d6ca95b5d72eaec92349a1f16846344f7b88128587e10"\
    && buildDeps=' \
        unzip \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -fSL -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL \
    && echo "$ELIXIR_DOWNLOAD_SHA256 elixir-precompiled.zip" | sha256sum -c - \
    && unzip -d /usr/local elixir-precompiled.zip \
    && rm elixir-precompiled.zip \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y erlang-snmp git htop

CMD ["R"]
