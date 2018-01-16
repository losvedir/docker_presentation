# Docker on AWS Part 1

AWS offers multiple ways to run Docker containers in the cloud. We use two approaches here at CTD. The first is well suited to web applications and is called Elastic Beanstalk (EB). The other is for any sort of application and is called Elastic Container Service (ECS).

Note that for simplicity here I've switched back to a simple single stage Dockerfile that runs `mix` as the `CMD`, for simplicity, rather than a multi-stage Dockerfile and distillery releases. However, in real life we do the more complex thing on AWS.

For demonstrating EB and ECS, I'll use the same app and Dockerfile, described below.

In this demo, I've used `mix phx.new` to generate a barebones Phoenix application. You should be able to run it locally the usual way:

```
7/demo $ mix deps.get
7/demo $ mix phx.server
```

Then you can load the home page in the browser at http://localhost:4000.

Now the Dockerfile should be pretty familiar at this point, except for one extra instruction:

```Dockerfile
FROM elixir:1.5
EXPOSE 4000
COPY demo .
RUN mix do deps.get, compile
CMD ["mix", "phx.server"]
```

We pull from `elixir:1.5`, copy in our phoenix application code, and compile it. We use `EXPOSE 4000` to indicate that this container listens on port 4000. It doesn't actually *do* anything and serves more as documentation, which we'll see in a moment.

Our `CMD` this time, is the usual one to run Phoenix `mix phx.server`.

We can build and run the docker image as usual:

```
7 $ docker build -t demo:7 .
7 $ docker run -d demo:7
```

See with `docker ps` that the container *is* running. However, if you navigate to http://localhost:4000 it won't work! That's because the container is in its own little world, and how we can safely run multiple containers on the same OS. In order for it to connect to the outside world, we need to manually expose its ports when we run the container. The `EXPOSE` instruction doesn't open the port itself, but lets whoever's running the `run` command know which ports to expose. Kill this container with `docker kill`, and then run it exposing the port:

```
7 $ docker run -d -p 4000:4000 demo:7
```

This maps the host's port 4000 to the container's port 4000. Visit http://localhost:4000 and see that the page loads now. It's also interesting to try `docker logs [container_hash]` to see its logs.


## Elastic Beanstalk

The way Elastic Beanstalk works with Docker is that you can upload a zipped archive of all your files, as well as a Dockerfile in the top level directory which it will use to build and then run a docker image. `dotcom`, `api`, and `open-trip-planner` use this approach.

Now let's run it on AWS EB.

Zip it up, upload it to EB.

## Elastic Container Service

With the ECS approach, we build a docker image elsewhere (Semaphore), and upload it to our ECS image registry. It's like Docker Hub but private. We can then run those images on instances we control, or in their general shared cloud called "Fargate". The ECS approach is used by our `rtr` and `concentrate` applications.

