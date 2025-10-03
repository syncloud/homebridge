#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap/homebridge
mkdir -p ${BUILD_DIR}
cp -r /etc ${BUILD_DIR}
cp -r /opt ${BUILD_DIR}
cp -r /usr ${BUILD_DIR}
cp -r /bin ${BUILD_DIR}
cp -r /lib ${BUILD_DIR}
cp -r ${DIR}/bin/* ${BUILD_DIR}/bin

sed -i 's#/usr/bin/env node#/snap/homebridge/current/homebridge/bin/node.sh#g' $BUILD_DIR/opt/homebridge/bin/npm
