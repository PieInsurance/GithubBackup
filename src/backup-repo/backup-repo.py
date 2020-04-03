#!python3

import boto3
import os
import tempfile
from git import Repo
from ZipFile import zipfile
from datetime import date

def _get_or_create_codecommit(key, secret, repo):
  client = boto3.client(
    'codecommit',
    aws_access_key_id=key,
    aws_secret_access_key=secret,
    region_name='us-west-2'
  )
  try:
    response = client.get_repository(repositoryName=repo)
  except:
    response = client.create_repository(
      repositoryName=repo,
      repositoryDescription=f"Backup of PieInsurance/{repo}"
    )
  return response['cloneUrlHttp']

def _clone_repo(token, repository):
  uri=f"https://{token}:x-oauth-basic@github.com/PieInsurance/{repository}"
  return Repo.clone_repo(uri, f"{repository}")

def _archive_repo(repository):
  timestamp = today.strftime("%d-%m-%Y-%H-%M-%S")
  filename=f"{repository}-{timestamp}.zip"
  with ZipFile(, 'w') as zf:
    for root, dirs, files in os.walk(f"./{repository}"):
      for f in files:
        zf.write(os.path.join(root, f))
  return filename

def _upload_to_s3(key, secret, bucket, filename):
  client = boto3.client(
    's3',
    aws_access_key_id=key,
    aws_secret_access_key=secret,
    region_name='us-west-2'
  )
  response = client.upload_file(filename, bucket, filename)

def handle(event, context):
  with tempfile.TemporaryDirectory() as tmpdirname:
    ## backup to codecommit
    codecommit_url = _get_or_create_codecommit(event['AWSAccessId'], event['AWSSecretKey'], event['Repository'])
    repo = _clone_github_repo(event["GithubToken"], event["Repository"])
    repo.create_remote('codecommit', url=codecommit_url)
    r.remotes.codecommit.push()
    ## backup to s3
    zipfile = _archive_repo(event["Repository"])
    _upload_to_s3(event['AWSAccessId'], event['AWSSecretKey'], event['S3Bucket'], zipfile)
