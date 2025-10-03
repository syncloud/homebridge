#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}
VERSION=$1
BUILD_DIR=${DIR}/../build/snap/homebridge

UI_DIR=${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x
sed -i 's#app\.listen\(.*\);#app.listen({path: "/var/snap/homebridge/common/web.socket"});#g' ${UI_DIR}/dist/main.js
sed -i '/async findHomebridgePath() {/a this.homebridgeModulePath = "\/snap\/homebridge\/current\/backend\/node_modules\/homebridge";' ${UI_DIR}/dist/bin/hb-service.js

#grep -C 3 "async findHomebridgePath() {" ${UI_DIR}/bin/hb-service.js

wget https://github.com/cyberb/homebridge-config-ui-x/archive/refs/heads/v$VERSION.tar.gz
tar xf v$VERSION.tar.gz
cd homebridge-config-ui-x-$VERSION
npm ci
cd ui
npm ci
cd ..
npm run build

ls $UI_DIR/dist
rm -rf $UI_DIR/dist
ls dist
mv dist $UI_DIR
rm -rf $UI_DIR/node_modules
mv node_modules $UI_DIR
rm -rf $UI_DIR/public
mv public $UI_DIR
#rm -rf $UI_DIR/scripts
#mv scripts $UI_DIR
#cp package.json $UI_DIR





