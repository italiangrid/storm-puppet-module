#!/bin/bash
set -ex

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then

    docker tag italiangrid/docker-rspec-puppet:ci ${DOCKER_REGISTRY_HOST}/italiangrid/docker-rspec-puppet:ci
    docker push ${DOCKER_REGISTRY_HOST}/italiangrid/docker-rspec-puppet:ci

fi
