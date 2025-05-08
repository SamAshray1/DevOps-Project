## Using Kubeadm

 1. Initializes cluster master node:
 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

 2. Initialize cluster networking:
 kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

### Task details
1. Create a new kind cluster by disabling the default CNI
2. Install Calico / Kube Router Network Add-on to your Kind cluster
3. Create 3 deployments with as below:
    name: frontend , image-name: nginx , replicas=1 , containerPort
    name: backend , image-name: nginx , replicas=1 , containerPort
    name: db , image-name: mysql , replicas=1 , containerPort: 3306
4. Expose all of these applications on a nodePort service with the same name as the deployment name
5. Do the connectivity test that all of your pods are able to interact with each other.
6. Create a network policy and restrict the access so that only backend pod should be able to access the db service on port 3306.
7. Attach this network policy to the backend deployment