#!/bin/bash -eux

__DEFAULT_SEMVER__="0.0.0"
SEMVER="${1:-${__DEFAULT_SEMVER__}}"
USERNAME="${2}"
PASSWORD="${3}"
URL="${4}/document"

FILENAME="deployment.${SEMVER%+*}.zip"

function ZipData {
  local _filename="${1}"
  local _version="${2}"
  local _files=($(find ./cd -type f ! -name .gitkeep | xargs))
  echo "=== COMPRESS DATA ==="
  echo "${_version}" > .version
  zip -r9 "${_filename}" ".version"
  zip -ur9 "${_filename}" "${_files[@]}"
}

function ArchiveData {
  local _filename="${1}"
  local _username="${2}"
  local _password="${3}"
  local _url="${4}"
  echo "=== ARCHIVE DATA ==="
  local _returncode=0
  local _code=$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' --upload-file "${_filename}" --user "${_username}:${_password}" "${_url}/${_filename}")
  case "${_code}" in
    2**);;
    400);;
    *) exit "${_code}";;
  esac
}

ZipData "${FILENAME}" "${SEMVER}"

if [ "${SEMVER}" != "${__DEFAULT_SEMVER__}" ]
then
  ArchiveData "${FILENAME}" "${USERNAME}" "${PASSWORD}" "${URL}"
else
  echo "Don't publish developer versions"
fi
