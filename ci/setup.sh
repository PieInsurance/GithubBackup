#!/bin/bash -eux

function Clean {
  git clean -dfx
}

function InstallRequirements {
  local _directories=($(ls -d ./src/*))
  local _directory=''
  for _directory in "${_directories[@]}"
  do
    cd "${_directory}"
      python3 -m virtualenv env
      ./env/bin/python3 -m pip install --upgrade pip
      ./env/bin/python3 -m pip install -f ./requirements.txt
    cd -
  done
}

Clean
InstallRequirements
