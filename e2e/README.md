## Multus e2e test with kind

### How to test e2e

<!-- todo - this read me is ripped right from multus, so clean it up! -->


```
$ git clone https://github.com/k8snetworkplumbingwg/multus-cni.git
$ cd multus-cni/e2e
$ ./get_tools.sh
$ ./generate_yamls.sh
$ ./setup_cluster.sh
$ ./test-simple-macvlan1.sh
```

### How to teardown cluster

```
$ ./teardown.sh
```
