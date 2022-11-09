#!/bin/sh
set -o errexit

kind create cluster --config yamls/cluster-config.yaml --name ci-cluster

# install calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true
kubectl -n kube-system set env daemonset/calico-node FELIX_XDPENABLED=false

kubectl -n kube-system wait --for=condition=available deploy/coredns --timeout=300s

#install multus
kubectl create -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset.yml
sleep 3
kubectl -n kube-system wait --for=condition=ready -l name=multus pod --timeout=660s
kubectl create -f yamls/cni-install.yaml
sleep 3
kubectl -n kube-system wait --for=condition=ready -l name=cni-plugins pod --timeout=300s