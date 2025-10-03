#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}
VERSION=$1

BUILD_DIR=${DIR}/../build/snap/backend

mkdir $BUILD_DIR
cd $BUILD_DIR
npm i homebridge@$VERSION

sed -i 's#/usr/bin/env node#/snap/homebridge/current/homebridge/bin/node.sh#g' $BUILD_DIR/node_modules/homebridge/bin/homebridge

head $BUILD_DIR/node_modules/homebridge/bin/homebridge

sed -i 's#silent: true#silent: true, execPath: process.env.UIX_CUSTOM_NODEJS_PATH#g' $BUILD_DIR/node_modules/homebridge/lib/childBridgeService.js