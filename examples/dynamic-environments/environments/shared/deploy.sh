#!/bin/bash

option=$1 # create or update
environment="shared"
template_name="$environment.yaml"
stack_name="test-shared-infra-001"
s3_bucket="test001-infrastructure-common"
aws_region="us-west-2"
tags="Key=Project,Value=test001"
export AWS_REGION=$aws_region
echo "Uploading CF template."
aws s3 cp $template_name s3://$s3_bucket/environments/$environment/ --profile test001
echo ""
echo "Creating CF stack."
aws cloudformation $option-stack --stack-name $stack_name \
                                  --template-url https://$s3_bucket.s3.$aws_region.amazonaws.com/environments/$environment/$template_name \
                                  --tags $tags \
                                  --capabilities CAPABILITY_AUTO_EXPAND \
                                  --profile test001
