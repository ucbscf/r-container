#!/bin/bash

VERSION=4.1.0

## basic usage
docker run -it --rm r-test:${VERSION}

## GUI-based usage that allows one to display plotting windows
docker run -it --rm --net=host --env="DISPLAY" -v ${HOME}/.Xauthority:/root/.Xauthority:rw r-test:${VERSION}
## could also do --env DISPLAY=${DISPLAY}
