## Task details

# Taint both of your worker nodes as below
# worker01--> gpu=true:NoSchedule , worker02--> gpu=false:NoSchedule
kubectl taint nodes node2 node3 gpu=true:NoSchedule

# Create a new pod with the image nginx and see why it's not getting scheduled on worker nodes and control plane nodes.
kubectl run nginx --image=nginx

# Create a toleration on the pod gpu=true:NoSchedule to match with the taint on worker01
# The pod should be scheduled now on worker01
kubectl apply -f pod.yml

# Delete the taint on the control plane node
kubectl taint node node1 gpu=true:NoSchedule-
kubectl taint node node1 node-role.kubernetes.io/control-plane:NoSchedule-

# Create a new pod with the image redis , it should be scheduled on control plane node
kubectl run redis --image=redis

# Add the taint back on the control plane node(the one that was removed)
kubectl taint node node1 node-role.kubernetes.io/control-plane:NoSchedule
