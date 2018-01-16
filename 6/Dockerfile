FROM elixir:1.5 as builder
COPY demo .
RUN mix do deps.get, compile
RUN mix release --verbose

FROM alpine:latest

COPY --from=builder /root/_build/dev/rel/rtr/releases/current/rtr.tar.gz .
RUN tar -xzf rtr.tar.gz
CMD ["bin/rtr", "foreground"]
