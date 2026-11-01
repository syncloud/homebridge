#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}
VERSION=$1
BUILD_DIR=${DIR}/../build/snap/homebridge

export npm_config_fetch_retries=5
export npm_config_fetch_retry_mintimeout=20000
export npm_config_fetch_retry_maxtimeout=120000
export npm_config_fetch_timeout=600000

npm_ci() {
  for i in $(seq 1 5); do
    if npm ci; then
      return 0
    fi
    echo "retry npm ci in $(pwd)"
    rm -rf node_modules
    sleep 30
  done
  echo "failed npm ci in $(pwd)"
  return 1
}

UI_DIR=${BUILD_DIR}/opt/homebridge/lib/node_modules/homebridge-config-ui-x
sed -i 's#app\.listen\(.*\);#app.listen({path: "/var/snap/homebridge/common/web.socket"});#g' ${UI_DIR}/dist/main.js
sed -i '/async findHomebridgePath() {/a this.homebridgeModulePath = "\/snap\/homebridge\/current\/backend\/node_modules\/homebridge";' ${UI_DIR}/dist/bin/hb-service.js

${DIR}/../download-retry.sh https://github.com/cyberb/homebridge-config-ui-x/archive/refs/heads/v$VERSION.tar.gz v$VERSION.tar.gz
tar xf v$VERSION.tar.gz
cd homebridge-config-ui-x-$VERSION
npm_ci
cd ui
npm_ci
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
