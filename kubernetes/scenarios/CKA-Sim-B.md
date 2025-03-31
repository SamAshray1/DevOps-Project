### Question 14 | Find out Cluster Information | 2 of 5
You're ask to find out following information about the cluster:

    How many controlplane nodes are available?
    How many worker nodes are available?
    What is the Service CIDR?
    Which Networking (or CNI Plugin) is configured and where is its config file?
    Which suffix will static pods have that run on cka8448?

Write your answers into file /opt/course/14/cluster-info, structured like this:

# /opt/course/14/cluster-info

3. cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep range
4.  find /etc/cni/net.d/

# How many controlplane nodes are available?
1: 1

# How many worker nodes are available?
2: 0

# What is the Service CIDR?
3: 10.96.0.0/12

# Which Networking (or CNI Plugin) is configured and where is its config file?
4: Weave, /etc/cni/net.d/10-weave.conflist

# Which suffix will static pods have that run on cka8448?
5: -cka8448