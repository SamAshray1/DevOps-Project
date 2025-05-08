## Troubleshooting Clusters

# Listing your cluster

The first thing to debug in your cluster is if your nodes are all registered correctly.
kubectl get nodes

And verify that all of the nodes you expect to see are present and that they are all in the Ready state.

To get detailed information about the overall health of your cluster, you can run:
kubectl cluster-info dump

kubectl describe node kube-worker-1

Control Plane nodes

    /var/log/kube-apiserver.log - API Server, responsible for serving the API
    /var/log/kube-scheduler.log - Scheduler, responsible for making scheduling decisions
    /var/log/kube-controller-manager.log - a component that runs most Kubernetes built-in controllers, with the notable exception of scheduling (the kube-scheduler handles scheduling).

Worker Nodes

    /var/log/kubelet.log - logs from the kubelet, responsible for running containers on the node
    /var/log/kube-proxy.log - logs from kube-proxy, which is responsible for directing traffic to Service endpoints