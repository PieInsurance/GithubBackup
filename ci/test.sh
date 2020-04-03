#!/bin/bash -eux

CONFIGURATION="${1:-Release}"
VERBOSITY="${2:-detailed}"

function ListTests {
  local _configuration="${1}"
  echo "=== LIST UNIT TESTS ==="
  dotnet test \
    --no-build \
    --list-tests \
    --configuration ${_configuration}
}

function UnitTests {
  local _configuration="${1}"
  local _verbosity="${2}"
  echo "=== TEST ==="
  dotnet test \
    --blame \
    --no-build \
    --configuration ${_configuration} \
    --verbosity ${_verbosity}
}

ListTests "${CONFIGURATION}"
UnitTests "${CONFIGURATION}" "${VERBOSITY}"
