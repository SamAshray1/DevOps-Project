## Namespaces
In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Namespace-based scoping is applicable only for namespaced objects (e.g. Deployments, Services, etc.) and not for cluster-wide objects (e.g. StorageClass, Nodes, PersistentVolumes, etc.).

When to Use Multiple Namespaces
Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all.

Initial namespaces
Kubernetes starts with four initial namespaces:

default
    Kubernetes includes this namespace so that you can start using your new cluster without first creating a namespace.
kube-node-lease
    This namespace holds Lease objects associated with each node. Node leases allow the kubelet to send heartbeats so that the control plane can detect node failure.

kube-public
    The kube-public namespace serves as a repository for resources that need to be publicly accessible within the cluster, like cluster-wide configuration dat

kube-system
    The namespace for objects created by the Kubernetes system.


kubectl get namespace
kubectl run nginx --image=nginx --namespace=namespace-name
kubectl get pods --namespace=namespace-name
kubectl config set-context --current --namespace=namespace-name