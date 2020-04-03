#!/bin/bash -eux

SEMVER="${1}"
BRANCH="${2}"
GIT_URL="${3}"
GIT_USERNAME="${4}"
GIT_PASSWORD="${5}"

function WaitForLogs {
  sleep 0.5
}

function SetupGit {
  git config user.name 'jenkins'
  git config user.email 'devops@pieinsurance.com'
}

function GenerateTag {
  local _semver="${1}"
  echo "${_semver%+*}"
}

function GitTag {
  local _tag="${1}"
  git tag "${_tag}" -m "Release Candidate"
}

function GitPushTag {
  local _tag="${1}"
  local _branch="${2}"
  local _git="${3}"
  git push "${_git}" "${_tag}" "HEAD:${_branch}"
}

function TagIfNotYetTagged {
  local _tag=$(GenerateTag "${1}")
  local _branch="${2}"
  local _git_url="${3}"
  local _git_username="${4}"
  local _git_password="${5}"
  local _git="${_git_url/https:\/\//https:\/\/${_git_username}:${_git_password}@}"

  if [ $(git rev-parse "${_tag}" 2>/dev/null) == "${_tag}" ]
  then
    SetupGit
    WaitForLogs
    GitTag "${_tag}"
    WaitForLogs
    GitPushTag "${_tag}" "${_branch}" "${_git}"
  else
    echo "Build already tagged"
  fi
}

TagIfNotYetTagged "${SEMVER}" "${BRANCH}" "${GIT_URL}" "${GIT_USERNAME}" "${GIT_PASSWORD}"
