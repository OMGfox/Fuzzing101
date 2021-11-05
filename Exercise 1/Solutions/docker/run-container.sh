#!/usr/bin/env bash

docker build --build-arg cuid=$(id -u) --build-arg cgid=$(id -g) --build-arg cuidname=$(id -un) --build-arg cgidname=$(id -gn) -t xpdf-fuzz -f Dockerfile . && \
docker run -it --rm --name xpdf-fuzz-container --privileged -v "$(pwd)/out":/home/$(id -un)/out xpdf-fuzz $1
