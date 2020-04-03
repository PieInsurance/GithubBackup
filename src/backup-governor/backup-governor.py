#!python3

import boto3
from github import Github

def _get_repos(token, ):
  g = Github(token)
  org = g.get_organization("PieInsurance")
  return org.get_repos()

def _create_payload(token, aws_key, aws_secret, aws_s3_bucket, repo):
  return {
    "GithubToken": token,
    "AWSAccessId": aws_key,
    "AWSSecretKey": aws_secret,
    "S3Bucket": aws_s3_bucket,
    "Repository": repo
  }

def _invoke_lambda(payload, invocation_type):
  client = boto3.client(
    'lambda',
    aws_access_key_id=key,
    aws_secret_access_key=secret,
    region_name='us-west-2'
  )
  return client.invoke(
    FunctionName='backup-repo',
    InvocationType=invocation_type,
    Payload=payload
  )

def handle(event, context):
  repositories = _get_repos(event['GithubToken'])
  for repository in repositories:
    payload = _create_payload(event['GithubToken'], event['AWSAccessId'], event['AWSSecretKey'], event['S3Bucket'], repository.name)
    response[repository.name] = _invoke_lambda(_payload, 'Event')
