# Running containers

Previously, the container started up, ran, and then ended. Now we'll see a container that keeps running and how to poke at it.

## The Dockerfile

Here's the new Dockerfile:

``` Dockerfile
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

That will return a long hash identifying the running container, but give back the command prompt. To see running docker containers you can use the following command:

```
docker ps
```

Note that there is a process running with the same hash as the one just returned.

One thing that you can do is execute a shell running on that same container:

```
docker exec -it [hash] /bin/ash
```

Inside the shell, you can see the bash script running in another process with

```
ps
```

Leave the shell with `Ctrl-D`.

To reiterate the class vs. instance point, try starting another container based on the same image:

```
docker run -d demo:4
```

If you do `docker ps` now, you should see two processes. Verify that one of them is running with the `docker logs` command:

```
docker logs [container]
```

You can also kill a container:

```
docker kill [container]
docker ps # to see that it's no longer running
```

Another way to stop the container is to attach your shell's STDIN/OUT/ERR to it, and then send a Ctrl-C that way:

```
docker attach [container]
Ctrl-C
docker ps
```

## Layers

One interesting thing to understand about the docker system is that each image is composed of several layers. Run the docker build command again, and pay close attention to the output. Here's what I have:

```
$ docker build -t demo:4 4/
Sending build context to Docker daemon  6.656kB
Step 1/4 : FROM alpine:latest
 ---> 3fd9065eaf02
Step 2/4 : RUN mkdir "scripts"
 ---> Using cache
 ---> bc8d5e115dea
Step 3/4 : COPY script.sh scripts
 ---> Using cache
 ---> 683c5a209298
Step 4/4 : CMD ["ash", "scripts/script.sh"]
 ---> Using cache
 ---> d471e1899611
Successfully built d471e1899611
Successfully tagged demo:4
```

Notice all the `--> [hash]` lines. Each line of the `Dockerfile` actually generates an intermediate image. You can see all these images if you run `docker images --all` (the `-all` includes intermediate images, which are normally hidden).

Just like any docker image, you can run a container based on them with `docker run`. If you include a command at the end of `docker run` it will run that command in the context of the container. Try running `docker run -it [hash] /bin/ash` for each of those steps, and comparing the output of `ls` with regard to the presence of the `scripts` directory and the `scripts/script.sh` file.

This is an optimization that docker provides: if different scripts share layers (e.g., same base image, or same few commands on top of that base image) then the actual images themselves are shared.
