#!/bin/bash
set -e
cd ./example || exit
npm install
pod-install --quiet
