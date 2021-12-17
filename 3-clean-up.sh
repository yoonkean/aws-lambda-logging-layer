#!/bin/bash
set -eo pipefail
STACK=test-lambda-function
if [[ $# -eq 1 ]] ; then
    STACK=$1
    echo "Deleting stack $STACK"
fi
FUNCTION=$(aws cloudformation describe-stack-resource --stack-name $STACK --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text)
aws cloudformation delete-stack --stack-name $STACK
echo "Deleted $STACK stack."

if [ -f bucket-name.txt ]; then
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    if [[ ! $ARTIFACT_BUCKET =~ lambda-artifacts-[a-z0-9]{16} ]] ; then
        echo "Bucket was not created by this application. Skipping."
    else
        while true; do
            read -p "Delete deployment artifacts and bucket ($ARTIFACT_BUCKET)? (y/n)" response
            case $response in
                [Yy]* ) aws s3 rb --force s3://$ARTIFACT_BUCKET; rm bucket-name.txt; break;;
                [Nn]* ) break;;
                * ) echo "Response must start with y or n.";;
            esac
        done
    fi
fi

RESULTS=$(aws logs describe-log-groups --log-group-name-prefix /aws/lambda/${FUNCTION})
LOG_GROUPS_COUNT=$(echo $RESULTS | jq '.logGroups | length')

if [ $LOG_GROUPS_COUNT -gt 0 ]; then
    while true; do
        read -p "Delete function log group (/aws/lambda/$FUNCTION)? (y/n)" response
        case $response in
            [Yy]* ) aws logs delete-log-group --log-group-name /aws/lambda/$FUNCTION; break;;
            [Nn]* ) break;;
            * ) echo "Response must start with y or n.";;
        esac
    done
fi


rm -f out.yml out.json
rm -rf aws-logging-layer/nodejs/package-lock.json