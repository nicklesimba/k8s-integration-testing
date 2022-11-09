#!/bin/sh
set -o errexit

# Pod readiness check helper function.
pod_run_check() {
    if [[ $(kubectl wait --for=condition=ready pod --all-namespaces -l $1 --timeout=30s) ]]; then
        echo "success (not sus)"
    else
        echo "failure (sus)"
        var_form=$(kubectl wait --for=condition=ready pod --all-namespaces -l $1 --timeout=30s | tee /dev/fd/2)
        # do logging here.
        echo $var_form
        # echo $(var_form) >> log.txt
        # var=$(echo hi | tee /dev/tty)
        # echo $var
    fi
}

# Runs against all pods in the cluster, and logs any failures.
check_pods_running () {
    
    pod_run_check k8s-app=calico-kube-condfdtrollers
    
    # kubectl wait --for=condition=ready pod --all-namespaces -l k8s-app=calico-kube-controllers --timeout=30s
    # after each of these commands, i need a function call to say "if error, log it"
    
    kubectl wait --for=condition=ready pod --all-namespaces -l k8s-app=calico-node --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l k8s-app=kube-dns --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l component=etcd --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l name=cni-plugins --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l app=kindnet --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l component=kube-apiserver --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l component=kube-controller-manager --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l k8s-app=kube-proxy --timeout=30s
    
    kubectl wait --for=condition=ready pod --all-namespaces -l component=kube-scheduler --timeout=30s

    # Multus check
    kubectl wait --for=condition=ready pod --all-namespaces -l app=multus --timeout=30s

    # Whereabouts check
    # (todo)
}

check_pods_running
pod_status=$?
[ $pod_status -eq 0 ] && echo "check_pods_running completed successfully" || echo "check_pods_running failed"

# echo "pre-meme"
# echo $pod_status
# echo "meme"
# kubectl get pods --all-namespaces -o json | jq -r '.items[].status.phase' | while read phase ; do
#     if [ ${phase} = "Running" ]; then
#         echo "Pod is healthy."
#     else
#         echo "Pod is not healthy."
#         # before exiting 
#         exit 1
#     fi
# done

# Technical todo
# - if any pod failure happens, we want to log it. stick that into some kind of log file (maybe by component or one big file)
# - failures of what: pods, reconciler controller (whereabouts), 
# - whereabouts/multus testing: create net-attach-def that uses whereabouts, launch pod that references that
#   - also want to check `ip a` and see if assigned ip address on interface is correct
# - next steps after this: enable other components beyond multus/whereabouts