FROM elixir:1.5
COPY demo .
RUN mix do deps.get, compile
CMD ["mix", "run", "--no-halt"]
