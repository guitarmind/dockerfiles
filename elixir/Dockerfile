FROM msaraiva/erlang:18.3
MAINTAINER Mark Peng <markpeng@exosite.com>

ENV ELIXIR_VERSION 1.4.5

RUN apk --update add --virtual build-dependencies wget ca-certificates && \
    wget --no-check-certificate https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    mkdir -p /opt/elixir-${ELIXIR_VERSION}/ && \
    unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ && \
    rm Precompiled.zip && \
    apk del build-dependencies && \
    rm -rf /etc/ssl && \
    rm -rf /var/cache/apk/*

ENV PATH $PATH:/opt/elixir-${ELIXIR_VERSION}/bin

RUN apk --update add ncurses-libs ca-certificates \
    erlang erlang-dev erlang-kernel erlang-hipe erlang-compiler \
    erlang-stdlib erlang-erts erlang-tools erlang-syntax-tools erlang-sasl \
    erlang-crypto erlang-public-key erlang-ssl erlang-ssh erlang-asn1 \
    erlang-inets erlang-mnesia erlang-odbc erlang-xmerl erlang-runtime-tools \
    erlang-observer erlang-os-mon erlang-erl-interface erlang-parsetools \
    erlang-snmp wget git g++ make libcurl bash && \
    rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
    mix local.rebar --force

CMD ["/bin/sh"]
