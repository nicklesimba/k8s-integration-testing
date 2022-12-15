#!/bin/sh
set -o errexit

# Pod readiness check helper function.
pod_run_check() {
    if result=$(kubectl wait --for=condition=ready pod --all-namespaces -l $1 --timeout=30s 2>&1); then
        stdout=$result
        echo $stdout
    else
        rc=$?
        stderr=$result
        echo $stderr >> log.txt
        echo $stderr
    fi
    
    # if [[ $(kubectl wait --for=condition=ready pod --all-namespaces -l $1 --timeout=30s 2>&1) ]]; then
    #     echo "success"
    # else
    #     echo "failure"
    #     var_form=$(kubectl wait --for=condition=ready pod --all-namespaces -l $1 --timeout=30s | tee /dev/fd/2)
    #     # do logging here. we want to log the following:
    #     # - standard error message that happens
    #     # - events tied to the pod (this link may help: https://stackoverflow.com/questions/51931113/kubectl-get-events-only-for-a-pod)
    #     echo $var_form
    #     # echo $(var_form) >> log.txt
    #     # var=$(echo hi | tee /dev/tty)
    #     # echo $var
    # fi
}

# Runs against all pods in the cluster, and logs any failures.
check_pods_running () {

    # General pod check
    pod_run_check k8s-app=kube-dns
    pod_run_check component=etcd
    pod_run_check name=cni-plugins
    pod_run_check app=kindnet
    pod_run_check component=kube-apiserver
    pod_run_check component=kube-controller-manager
    pod_run_check k8s-app=kube-proxy
    pod_run_check component=kube-scheduler

    # Multus check
    pod_run_check app=multus
    
    # Whereabouts check
    # (todo)
}

check_pods_running
pod_status=$?
[ $pod_status -eq 0 ] && echo "check_pods_running completed successfully" || echo "check_pods_running failed"


# Whereabouts/Multus Integration Test: 
# - create a net-attach-def that uses whereabouts, then launch a pod that references it (check that pod goes to running state afterward)
#   - also want to check `ip a` and see if assigned ip address on interface is correct
kubectl create -f ../yamls/whereabouts-nad.yaml
kubectl create -f ../yamls/whereabouts-pod.yaml
pod_run_check app=whereabouts 
samplepod_ips=$(kubectl exec -it samplepod -- hostname -I)
samplepod_ip=$(cut -d' ' -f2 <<<$samplepod_ips)
samplepod_ip_lastnum=$(cut -d'.' -f4 <<<$samplepod_ip)
echo $samplepod_ip_lastnum
if (( samplepod_ip_lastnum > 16 )) && (( samplepod_ip_lastnum < 32 )) ; then
    echo "success!"
else
    echo "failure!"
    stderr=$result
    echo "samplepod ip ($samplepod_ip) not in expected range (10.244.1.16 - 10.244.1.31)"  >> log.txt
fi

# _________/Multus Integration Test: 
# - description goes here
