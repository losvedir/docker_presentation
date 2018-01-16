# Distillery and Multi stage build

While `elixir:1.5` is great to develop with, it's not great to deploy to production with. The image itself is huge (take a look at the size of the last slide's image in `docker images`), and it includes a lot of stuff that might be necessary to *build* the app, but not to *run* it. Think: ruby and npm to compile the SASS and JS. But once it's compiled, production only needs to serve the static assets.

That's where "multi stage builds" comes in. They let you specify multiple `FROM` instructions in the Dockerfile. Later `FROM` statements "reset" the image, but you can explicitly pull forward artifacts generated in the previous one.

This can even be done for Elixir/erlang. In this example, I use the `distillery` tool to build a "release" of the app, which is a tarball containing everything needed to run itself (even the BEAM VM!). Consequently, it can be run on a host that doesn't have erlang or elixir installed. I take advantage of that fact to run it on `alpine:linux`, in order to keep the file small.

First, see how releases work without going through Docker.

```
6/demo $ mix deps.get
6/demo $ mix release
```

See in the output that it spits out a script that you can invoke to run the app, something like `_build/prod/rel/rtr/releases/current/bin/demo foreground`. Also notice that there's a `.tar.gz` containing everything you need to run the app.

Now, here's the Dockerfile we're using:

```Dockerfile
FROM elixir:1.5 as builder
COPY demo .
RUN mix do deps.get, compile
RUN mix release --verbose

FROM alpine:latest
COPY --from=builder /root/_build/dev/rel/demo/releases/current/rtr.tar.gz .
RUN tar -xzf demo.tar.gz
CMD ["bin/demo", "foreground"]

```

THe first half is pretty standard. We pull from the `elixir:1.5` base image, but this time we name it `as builder` so we can refer to it later. Then we run some commands, including the `mix release` that we saw earlier.

The second half begins with *another* `FROM` instruction, which makes this a "multi stage" build. The image layers from here down are now very small again, because they're based on `alpine:latest`, not `elixir:1.5`. There's also another `COPY` instruction, which we've seen before, but now instead of copying from our own file system, it uses `--from=builder` to copy from the image named above. What we copy is the tarball associated with the release. We then unzip it, and give the `CMD` to run it.

Now take a look at `docker images`. Even though our app does the same thing as last time, it's now dramatically smaller!

This "multi stage build" feature is relatively new. Previously, the same effect was achieved through two separate Dockerfiles and a script that ran the first one, copied its output to the host, ran the second one, and copied it into the new image. (This is how the `dotcom` repo works currently.) Newer apps like `rtr` and `concentrate` use the multi-stage approach.
