#!/bin/bash
set -e

docker build --pull=false --rm=true --no-cache=true -t italiangrid/docker-rspec-puppet .
