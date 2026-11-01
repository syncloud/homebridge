#!/bin/bash -e

DIR=$(cd "$(dirname "$0")" && pwd)
cd "$DIR"

SPEC=$1
if [ -z "$SPEC" ]; then
  echo "usage: $0 <spec>"
  exit 1
fi

export PLAYWRIGHT_FULL_DOMAIN=bookworm.com
export PLAYWRIGHT_APP_DOMAIN=homebridge.bookworm.com
export PLAYWRIGHT_DEVICE_HOST=homebridge.bookworm.com
export PLAYWRIGHT_DEVICE_USER=user
export PLAYWRIGHT_DEVICE_PASSWORD=Password1
export PLAYWRIGHT_SSH_USER=root
export PLAYWRIGHT_SSH_PASSWORD=Password1
export PLAYWRIGHT_SPEC_NAME=$(basename "$SPEC" .spec.ts)
export PLAYWRIGHT_ARTIFACT_DIR=$(cd "$DIR/../.." && pwd)/artifact

${DIR}/../../apt.sh sshpass openssh-client curl
${DIR}/wait-app.sh ${PLAYWRIGHT_APP_DOMAIN}
npm ci --no-audit --no-fund
npx playwright test --project=desktop "$SPEC"
