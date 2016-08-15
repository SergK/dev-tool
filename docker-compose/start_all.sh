#!/bin/bash

COMPOSE_PATH=${COMPOSE_PATH:-"$(pwd)"}

docker-compose -f ${COMPOSE_PATH}/docker-compose.yml up -d --no-recreate
