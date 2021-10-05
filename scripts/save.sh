#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}
log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&1
}

folder=$1

if [ -z "$folder" ]; then
  err "need to input the folder name"
  exit 1
fi

log save to ${folder}

cd examples
mkdir ${folder}
cp -R ../src ${folder}
cp ../tsconfig.json ${folder}