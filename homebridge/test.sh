#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap/php
${BUILD_DIR}/homebridge/opt/homebridge/bin/node --version
${BUILD_DIR}/homebridge/usr/local/bin/ffmpeg -version