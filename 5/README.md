# Elixir application

In this example, we have an Elixir application that runs and just logs a message very couple seconds. Run it in your own environment:

```
5/demo $ mix do deps.get, compile
5/demo $ mix run --no-halt
```

Now let's see how the Dockerfile has it run in a container.

```Dockerfile
FROM elixir:1.5
COPY demo .
RUN mix do deps.get, compile
CMD ["mix", "run", "--no-halt"]
```

Until now, we've used `alpine:latest` as the base image. This is a great, barebones image. However, one of the neat things about docker is all the available images on Docker Hub that you can use. There's one that we use called `elixir:1.5` and it's an image that already has erlang and elixir installed in it. By pulling from `elixir:1.5` here, we know that `mix` is already installed and up to date. We've also pegged the version at Elixir 1.5. (We could do `elixir:latest` to always get the newest one, but that's bad for deploying to production.)

The second instruction copies the elixir code in our `demo` directory into the image we're building.

The third instruction runs `mix` inside the image to get its dependenices and compile the app.

The last instruction is so the container knows to run `mix run --no-halt` when it runs the image.

Let's build the image and then run it:

```
5 $ docker build -t demo:5 .
5 $ docker run demo:5
```

It's also worth looking at the intermediate images that are generated. Try doing `docker run [hash] /bin/bash` against the first image (the one that just has `elixir:1.5`). Note that since this image is built off debian, we use `/bin/bash` here and not `/bin/ash`. Once you have your shell, try running `iex` and you'll see that it's available.
