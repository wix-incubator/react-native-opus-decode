#!/bin/bash

if [ "${IS_BUILD_AGENT}" == true ]; then
    echo "SKIPPING CI TEST DUE TO COMPILE ISSUE ON AGENT"
else
  set -e
  npm install
  cd ./example || exit
  npm install
  pod-install --quiet
  react-native run-ios
  cd ..
  detox test
fi
