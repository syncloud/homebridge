#!/bin/bash -e
/bin/rm -f $SNAP_COMMON/web.socket
#export UIX_CUSTOM_PLUGIN_PATH=$SNAP/homebridge/opt/homebridge
exec $SNAP/homebridge/opt/homebridge/bin/node \
  $SNAP/homebridge/opt/homebridge/lib/node_modules/homebridge-config-ui-x/dist/bin/hb-service.js \
  run -I \
  -U $SNAP_DATA/storage \
  -P $SNAP_DATA/storage/node_modules \
  --strict-plugin-resolution "$@"

