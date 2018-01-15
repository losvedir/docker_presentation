# Using Docker

One of the confusing things about docker is the bountiful commands and jargon.

This directory demonstrates a very simple usage of docker to introduce the basics.

## Workflow

You write a *Dockerfile* in order to build an *image* that runs in a *container*.

* Dockerfile - this is a text document composed of a series of docker-specific instructions that tells it how to build an image.

* Image - I think of it as a (potentially very large) binary artifact produced by building the Dockerfile. Docker describes it as "An Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime."

* Container - "a runtime instance of an image". Think "classes" vs "instances" in OOP. One immutable docker image, which describes an environment, can get "instantiated" into multiple isolated containers, each with their own state.

* Docker Hub - an online repository of public docker images. Think "npm" or "hex.pm" for docker images.

All this is done with subcommands of the `docker` CLI tool.

* `docker build -t foo:latest path/to/dir` - this command turns a Dockerfile into an image.

  The image can be tagged with the `-t` flag to be easily referenced later. The tag is of the form `name:version`, and if the version is omitted, `:latest` is used.

  The command takes a directory as an argument and expects a file named `Dockerfile` to be in that directory. The Dockerfile can access other files in that directory.

* `docker images` - command to list the local images that docker knows about.

* `docker run foo:latest` - this will start running a container based on the image given to it.

## Explanation of this Dockerfile

This folder includes a Dockerfile with these contents:

``` Dockerfile
FROM alpine:latest
CMD ["echo", "hello world"]
```

Every Dockerfile begins by specifying a base image in a `FROM` statement. It will pull from the Docker Hub if it doesn't know that tag locally. In this case, I'm specifying `alpine`, which is a very barebones (5MB!) Linux distribution. Other examples would be `FROM debian:jessie` or `FROM ubuntu`.

The other instruction `CMD` tells the container what to run when it instantiates the image.

## Putting it all together

In this directory, we can build a docker image using this docker file:

```
$ docker build -t demo:3 .
```

Then we can see the image it built:

```
$ docker images
```

Then we can run the image. It will start a container, run its CMD, and then exit:

```
$ docker run demo:3
```
