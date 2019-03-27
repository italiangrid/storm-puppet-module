#!/bin/bash
set -e

tags=${tags:-"dev ci"}

for t in ${tags}; do
    docker build --pull=false \
      --rm=true  \
      -t italiangrid/docker-rspec-puppet:${t} -f Dockerfile.${t} .
done

