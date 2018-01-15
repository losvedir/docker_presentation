# Running containers

Previously, the container started up, ran, and then ended. Now we'll see a container that keeps running and how to poke at it.

## The Dockerfile

Here's the new Dockerfile:

```
FROM alpine:latest
RUN mkdir "scripts"
COPY script.sh scripts
CMD ["ash", "scripts/script.sh"]
```

As before, it builds off the `alpine:latest` base image.

Next there's a new instruction `RUN`, which executes a command in the image. Note that it's different from `CMD`: `RUN` makes changes inside the image _when it's built_, while `CMD` doesn't change the image itself, but rather tells the *container* what to execute when it's run. `RUN` is for the image, `CMD` is for the container. There may be several `RUN` instructions in a `Dockerfile`, but if there's a `CMD`, there's only one, and it's at the bottom.

In this case, we run `mkdir scripts` which will make a new `scripts/` directory inside the image.

Then there's a `COPY` command which allows you to move files into the image. In this case, I'm adding a simple script that infinitely loops and echoes.

Lastly, the `CMD` for the container to run is `ash scripts/script.sh` (alpine uses `ash`, not `bash`).

## Exploring running containers

As before, the image can be built with `docker build`, but we'll tag it as `demo:4` this time. Then we can run it.

```
docker build -t demo:4 .
docker run demo:4
```

The terminal should now be repeatedly printing out `alive...`. Kill it with `Ctrl-C`, and then re-run it in the background ("detached"):

```
docker run -d demo:4
```
