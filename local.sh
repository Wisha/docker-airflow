#!/usr/bin/env bash
set -e

# Read config
SOURCE ./PROJECT_CONFIG

# Build docker image of project
./build.sh

docker-compose -f docker-compose-LocalExecutor.yml up -d