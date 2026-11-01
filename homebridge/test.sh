#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap
${BUILD_DIR}/homebridge/bin/node.sh --version
${BUILD_DIR}/homebridge/bin/ffmpeg.sh -version
grep "/snap/homebridge/current/homebridge/bin/node.sh" ${BUILD_DIR}/backend/node_modules/homebridge/bin/homebridge.js
grep "execPath: process.env.UIX_CUSTOM_NODEJS_PATH" ${BUILD_DIR}/backend/node_modules/homebridge/dist/childBridgeService.js
