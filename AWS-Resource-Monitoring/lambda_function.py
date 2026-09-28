import boto3
import json

def lambda_handler(event, context):
    # Call the function to list AWS resources
    my_aws_resources()
    return {
        'statusCode': 200,
        'body': json.dumps('AWS resources have been successfully written to aws_resources.txt')
    }


def list_my_s3_buckets():
  # Create a boto3 client for S3
  s3_client = boto3.client('s3')

  # Call AWS to list buckets
  response = s3_client.list_buckets()

  lines =['Existing S3 Buckets:']
  # Loop through the dictionary response
  for i in response.get('Buckets', []):
    lines.append(f'  - {i["Name"]}')
  return lines

def list_my_ec2_instances():
  # Create a boto3 client for EC2
  ec2_client = boto3.client('ec2')

  # Call AWS to list instances
  response = ec2_client.describe_instances()

  lines = ['Existing EC2 Instances:']
  # Loop through the dictionary response
  for reservation in response.get('Reservations', []):
    for instance in reservation.get('Instances', []):
      lines.append(f'  - Instance ID: {instance["InstanceId"]}, State: {instance["State"]["Name"]}')
  return lines

def list_lambda_functions():
  # Create a boto3 client for Lambda
  lambda_client = boto3.client('lambda')

  # Call AWS to list Lambda functions
  response = lambda_client.list_functions()

  lines = ['Existing Lambda Functions:']
  # Loop through the dictionary response
  for function in response.get('Functions', []):
    lines.append(f'  - Function Name: {function["FunctionName"]}, Runtime: {function["Runtime"]}')
  return lines

def list_my_iam_users():
  # Create a boto3 client for IAM
  iam_client = boto3.client('iam')

  # Call AWS to list IAM users
  response = iam_client.list_users()

  lines = ['Existing IAM Users:']
  # Loop through the dictionary response
  for user in response.get('Users', []):
    lines.append(f'  - User Name: {user["UserName"]}, User ID: {user["UserId"]}')
  return lines

def my_aws_resources():
   with open('/tmp/aws_resources.txt', 'w') as f:
    for line in list_my_s3_buckets():
        f.write(line + '\n')
    for line in list_my_ec2_instances():
        f.write(line + '\n')
    for line in list_lambda_functions():
        f.write(line + '\n')    
    for line in list_my_iam_users():
        f.write(line + '\n')
    print("AWS resources have been successfully written to aws_resources.txt")
   with open('/tmp/aws_resources.txt', 'r') as f:
    try:
        print(f.read())
    except Exception as e:
        print(f"Error reading the file: {e}")
    # Save the file to S3 bucket
    s3_client = boto3.client('s3')
    s3_client.upload_file('/tmp/aws_resources.txt', 'mybucket775', 'aws_resources.txt')
    print("AWS resources have been successfully uploaded to S3 bucket")
