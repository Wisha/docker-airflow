#!/usr/bin/env bash
#set -e

# Read config
SOURCE ./PROJECT_CONFIG

# Get & store ECR login
$(aws ecr get-login --region ap-southeast-2 --no-include-email)

# Check if on EC2 instance
ON_EC2=`curl -sL -w "%{http_code}\\n" "http://169.254.169.254/latest/meta-data/" -o /dev/null -m 5`

if [ "$ON_EC2" = "200" ]; then
    export AWS_ECR_ACCOUNT_ID=`curl -sL http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info/ | jq -r '.AccountId'`
fi

# Build docker image
docker build -t $COMPONENT_NAME .
docker tag $COMPONENT_NAME\:latest $AWS_ECR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME\:latest
echo "Built image $COMPONENT_NAME:latest"