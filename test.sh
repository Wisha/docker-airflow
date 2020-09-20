#!/usr/bin/env bash

SOURCE ./PROJECT_CONFIG

export AWS_ACCESS_KEY_ID=$DEV_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$DEV_AWS_SECRET_ACCESS_KEY

$(aws ecr get-login --no-include-email --region $AWS_REGION)

docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/usr/local/airflow \
  -e AWS_ACCESS_KEY_ID=$DEV_AWS_ACCESS_KEY_ID
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  395178827165.dkr.ecr.ap-southeast-2.amazonaws.com/buildkite-python3:latest ./test_dev.sh