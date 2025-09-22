#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap
${BUILD_DIR}/homebridge/bin/node.sh --version
${BUILD_DIR}/homebridge/bin/ffmpeg.sh -version
#${BUILD_DIR}/backend/node_modules/homebridge/bin/homebridge --version
