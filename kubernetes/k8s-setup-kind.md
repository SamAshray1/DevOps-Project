# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64

chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Pre-requisites > docker, podman, or nerdctl have to be installed

# Creating Clusters
kind create cluster --image=...
kind create cluster --image=.. --config example-config.yml


# List Clusters
kind get clusters

# Delete Cluster
kind delete cluster
