#!/bin/bash -eux

__DEFAULT_SEMVER__="0.0.0"
SEMVER="${1:-${__DEFAULT_SEMVER__}}"
USERNAME="${2}"
PASSWORD="${3}"
URL="${4}/github-backup"

function WaitForLogs {
  sleep 0.5
}

function ZipLambda {
  local _semver="${1}"
  local _function="${2}" 
  local _filename="${_function}.${_semver}.zip"
  local _oldpwd=$(pwd)
  echo "=== ZIP LAMBDA (${_function}) ==="
  cd "./env/lib/python3.6/site-packages"
    zip -qr9 "${_oldpwd}/${_filename}" .
  cd "${_oldpwd}"
  zip -qg "${_filename}" $(ls ./*py | xargs)
}

function ZipAllLambdas {
  local _semver="${1}"
  local _directories=($(ls -d ./src/* | xargs))
  local _directory=''
  for _directory in "${_directories[@]}"
  do
    local _oldpwd=$(pwd)
    cd "${_directory}"
      ZipLambda "${_semver}" "${_directory##*/}"
      WaitForLogs
    cd "${_oldpwd}"
  done
}

function ArchiveLambda {
  local _filename="${1}"
  local _username="${2}"
  local _password="${3}"
  local _url="${4}"
  echo "=== ARCHIVE LAMBDAS ==="
  local _returncode=0
  local _code=$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' --upload-file "${_filename}" --user "${_username}:${_password}" "${_url}/${_filename}")
  case "${_code}" in
    2**);;
    400);;
    *) exit "${_code}";;
  esac
}

function ArchiveLambdas {
  local _username="${1}"
  local _password="${2}"
  local _url="${3}"
  local _filenames=($(ls ./src/**/*.zip | xargs))
  local _filename=''
  for _filename in "${_filenames}"
  do
    ArchiveLambda "${_filename}" "${_username}" "${_password}" "${_url}"
    WaitForLogs
  done
}

ZipAllLambdas "${SEMVER}"
ArchiveLambdas "${USERNAME}" "${PASSWORD}" "${URL}"
