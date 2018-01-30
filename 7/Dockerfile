FROM elixir:1.5
RUN mix local.hex --force
EXPOSE 4000
COPY demo .
RUN mix do deps.get, compile
CMD ["mix", "phx.server"]
