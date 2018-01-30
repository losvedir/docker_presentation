FROM elixir:1.5 as builder
ENV MIX_ENV=prod
COPY demo .
RUN mix local.hex --force
RUN mix do deps.get, compile
RUN mix release --verbose

FROM debian:jessie
ENV MIX_ENV=prod TERM=xterm LANG="C.UTF-8"
COPY --from=builder _build/prod/rel/demo/releases/latest/demo.tar.gz .
RUN tar -xzf demo.tar.gz
CMD ["bin/demo", "foreground"]
