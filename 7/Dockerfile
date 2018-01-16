FROM elixir:1.5
EXPOSE 4000
COPY demo .
RUN mix do deps.get, compile
CMD ["mix", "phx.server"]
