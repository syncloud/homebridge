#!/bin/sh -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd ${DIR}

cd ${DIR}/../build/snap/homebridge/opt/homebridge/lib
npm i homebridge@1.11.0
