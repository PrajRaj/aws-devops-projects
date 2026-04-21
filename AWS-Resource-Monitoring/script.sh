#!/bin/bash

#####################
#Author: Prajwal Raj
#Date : April 21, 2026
#
#Title: A script to report AWS resource usage
######################


#What are the AWS resources that are tracked

#AWS EC2
#AWS S3
#AWS LAMDA Functions
#AWS IAM Users

echo "####################################################"
echo "============= AWS RESOURCE USAGE REPORT ==========="
echo "Report generated on: $(date)"
echo "###################################################"

# Error Handling

if ! command -v aws &> /dev/null
then
    echo "AWS CLI not installed"
    exit 1
fi

# S3 Buckets

echo "1. S3 Buckets"
echo "Total Count:$(aws s3 ls | wc -l)"
echo "Bucket List:"
aws s3 ls | awk '{print " - " $3}' 

echo "---------------------------------"

# EC2 Instances

echo "2. EC2 Instances"
echo "Total Instances"
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text | wc -w
echo "Instance Id"
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text

echo "---------------------------------"

# Lambda functions
echo "3. Lambda Functions"
aws lambda list-functions --query 'Functions[].FunctionName' --output text | wc -w 

echo "---------------------------------"

# IAM users
echo "4. IAM Users"
echo "Number of IAM users"
aws iam list-users --query 'Users[].UserName' --output text | wc -w
echo "IAM Usernames"
aws iam list-users --query 'Users[].UserName' --output text

