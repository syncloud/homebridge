#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}
VERSION=$1

BUILD_DIR=${DIR}/../build/snap
ls -la $BUILD_DIR/homebridge/opt/homebridge/lib/node_modules

cd $BUILD_DIR/homebridge/opt/homebridge/lib
npm i homebridge@$VERSION

ls -la $BUILD_DIR/homebridge/opt/homebridge/lib/node_modules
