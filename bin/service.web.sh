#!/bin/bash -e
/bin/rm -f $SNAP_COMMON/web.socket
export UIX_CUSTOM_NODEJS_PATH=$SNAP/homebridge/bin/node.sh
export NODE_PATH=$SNAP/backend/node_modules
export HOMEBRIDGE_CONFIG_UI_SUDO=0
export PATH=$PATH:$SNAP/bin
$SNAP/homebridge/bin/node.sh \
  $SNAP/homebridge/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist/bin/hb-service.js \
  run -I \
  -U $SNAP_DATA/storage \
  -P $SNAP_DATA/storage/node_modules \
  --strict-plugin-resolution "$@"
