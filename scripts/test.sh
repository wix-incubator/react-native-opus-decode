#!/bin/bash
set -e
if [ "${BUILDKITE}" == true ]; then
    echo "SKIPPING CI TEST DUE TO COMPILE ISSUE ON AGENT"
else
  cd ./example || exit
  if [[ $(uname -m) == 'arm64' ]]; then
    arch -x86_64 react-native run-ios --verbose --simulator "iPhone 13"
  else
    react-native run-ios --simulator --verbose "iPhone 13"
  fi
  cd ..
  detox test
fi
