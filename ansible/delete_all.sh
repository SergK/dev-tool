#!/bin/bash

source config.sh

# Remove all containers
for NAME in ${CONTAINER_LIST[@]}; do
    docker rm -f "dev-tool-$NAME"
done

# Remove all images
for NAME in ${CONTAINER_LIST[@]}; do
    docker rmi "dev-tool-$NAME"
done
