#!/usr/bin/env bash
set -x
source ./PROJECT_CONFIG
REV=$(git rev-parse --short HEAD)

echo "BUILDKITE_BUILD_NUMBER: $1"

ON_EC2=`curl -sL -w "%{http_code}\\n" "http://169.254.169.254/latest/meta-data/" -o /dev/null -m 5`

echo "ON EC2: $ON_EC2"

if [ "$ON_EC2" = "200" ]; then
  export AWS_ECR_ACCOUNT_ID=`curl -sL http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info/ | jq -r '.AccountId'`
  docker tag $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:latest $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:$1
fi

echo "ON AWS_ECR_ACCOUNT_ID: $AWS_ECR_ACCOUNT_ID"

$(aws ecr get-login --region ap-southeast-2 --no-include-email)

docker tag $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:latest $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:$REV

docker push $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:$REV
docker push $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:latest

if [ "$ON_EC2" = "200" ]; then
  docker push $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:$1
fi

echo "COMPLETED"