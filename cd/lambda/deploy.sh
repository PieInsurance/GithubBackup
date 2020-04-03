#!/bin/bash -eux

# 1. upload *.zip files from nexus s3 to cloudformation s3
# 2. upload cft.yaml to cloudformation s3
# 3. apply cloudformation template

__DEFAULT_REGION__="us-west-2"

SEMVER="${1}"
AWS_ACCESS_KEY="${2}"
AWS_SECRET_KEY="${3}"
CLOUDFORMATION_BUCK="${4}"
ENVIRONMENT="${5}"
AWS_REGION="${6:-${__DEFAULT_REGION__}}"
CLOUDFORMATION_FOLDER="github-backup"

function WaitForLogs {
  sleep 0.5
}

function GetInitStackInfo {
  local _id="${1}"
  local _secret="${3}"
  echo "=== GET INIT STACK INFO ==="
  
}

function DownloadArtifactsFromNexus {
  local _username="${1}"
  local _password="${2}"
  local _uri
  echo "=== DOWNLOAD ARTIFACTS ==="

}

function UploadFileToCloudformationBucket {
  local _username="${1}"
  local _password="${2}"
  local _filename="${3}"
  local _bucket="${4}"
  echo "=== UPLOAD ARTIFACTS TO S3 ==="
  aws s3 cp "${_filename}" "${_bucket}/<service>/<semver>"
}

function ApplyCloudformation {
  local _id="${1}"
  local _secret="${2}"
  echo "=== APPLY CLOUDFORMATION ==="
}

function Deploy {
  GetInitStackInfo
  WaitForLogs
  DownloadArtifactsFromNexus
  WaitForLogs
  UploadFilesToCloudformationBucket
  WaitForLogs
  ApplyCloudformation
}
