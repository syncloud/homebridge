#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap/homebridge
cd ${BUILD_DIR}/homebridge/opt/homebridge/lib
npm i homebridge@1.11.0
