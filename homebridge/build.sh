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

sed -i 's#app\.listen\(.*\);#app.listen({path: "/var/snap/homebridge/common/web.socket"});#g' ${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist/main.js
sed -i 's#// Check the folder directly above#this.homebridgeModulePath = "/var/snap/homebridge/current/backend/node_modules/homebridge"#g' ${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist/bin/hb-service.js

mkdir ${BUILD_DIR}/homebridge
cd ${BUILD_DIR}/homebridge

