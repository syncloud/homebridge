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

UI_DIR=${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist
sed -i 's#app\.listen\(.*\);#app.listen({path: "/var/snap/homebridge/common/web.socket"});#g' ${UI_DIR}/main.js
sed -i '/async findHomebridgePath() {/a this.homebridgeModulePath = "\/snap\/homebridge\/current\/backend\/node_modules\/homebridge";' ${UI_DIR}/bin/hb-service.js

grep -C 3 "async findHomebridgePath() {" ${UI_DIR}/bin/hb-service.js
