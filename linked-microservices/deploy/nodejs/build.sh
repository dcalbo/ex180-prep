#!/bin/bash

rm -fr build
mkdir -p build
chmod a+x build/run.sh
chmod -R a+rwX build

sudo rm -rf {linked,kubernetes}/work

source /usr/local/etc/ocp4.config
podman build -t do180/todonodejs .