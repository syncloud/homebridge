#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}

BUILD_DIR=${DIR}/../build/snap/homebridge

#UI_DIR=${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist
#sed -i 's#app\.listen\(.*\);#app.listen({path: "/var/snap/homebridge/common/web.socket"});#g' ${UI_DIR}/main.js
#sed -i '/async findHomebridgePath() {/a this.homebridgeModulePath = "\/snap\/homebridge\/current\/backend\/node_modules\/homebridge";' ${UI_DIR}/bin/hb-service.js

#grep -C 3 "async findHomebridgePath() {" ${UI_DIR}/bin/hb-service.js

wget https://github.com/cyberb/homebridge-config-ui-x/archive/refs/heads/latest.tar.gz
tar xf latest.tar.gz
cd homebridge-config-ui-x-latest
npm i
cd ui
npm i
cd ..
npm run build

ls dist
ls ui/dist

rm -rf $UI_DIR
mv dist $UI_DIR

