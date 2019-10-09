#!/bin/bash
set -e

tag="ci"
name="docker-rspec-puppet"

docker build --pull=false --rm=true -t italiangrid/${name}:${tag} .

