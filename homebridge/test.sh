#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap/homebridge
${BUILD_DIR}/bin/node.sh --version
${BUILD_DIR}/bin/ffmpeg.sh -version
