#!/bin/bash

command -v kind > /dev/null 2>&1 || { echo >&2 "I require kind but it's not installed.  Aborting."; exit 1; }

KIND_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
K8S_VERSION="1.15.7"

kind create --name ${KIND_NAME} --config cluster.yaml --image kindest/node:v${K8S_VERSION}

