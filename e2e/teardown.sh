#!/bin/sh
set -o errexit

reg_name='kind-registry'
export PATH=${PATH}:./bin

# delete cluster kind
kind delete cluster --name ci-cluster

# i don't think anything after the "kind delete cluster" is doing anything?