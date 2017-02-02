FROM msaraiva/elixir:1.3.4
MAINTAINER Mark Peng <markpeng@exosite.com>

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
