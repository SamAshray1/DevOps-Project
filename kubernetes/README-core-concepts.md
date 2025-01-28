**History of K8s**
The design and development of Kubernetes was inspired by Google's Borg cluster manager and based on Promise Theory.
Kubernetes was released in 2015. Google worked with the Linux Foundation to form the Cloud Native Computing Foundation (CNCF) and offered Kubernetes as the seed technology.

**Monolithic vs Microservices**
Monolithic Architecture is single tier, where all the components are tightly coupled and deployed as a single unit.
Due to the tight coupling,
> Entire application may fail, if one component fails.
> Less flexible as each component cannot be developed, deployed and scaled independently.
Only pro is that communication is faster due to the coupling.

Microservices Architecture is multi-tier, where the components are small, loosely coupled and each individual component/service can be deployed independently.
> Individual components can be developed, deployed and scaled independently.
> An individual service can fail without affecting the other services.
There is more complexity while managing, and also the communication between components is slower due to network calls. 

**Kubernetes Architecture**
<img src="https://upload.wikimedia.org/wikipedia/commons/b/be/Kubernetes.png">

*Control Plane*
The Kubernetes master node handles the Kubernetes control plane of the cluster, managing its workload and directing communication across the system.
The various components of the Kubernetes control plane are as follows.

*Etcd*
Etcd is a persistent, lightweight, distributed, key-value data store. It reliably stores the configuration data of the cluster, representing the overall state of the cluster at any given point of time.

*API Server*
The API server serves the Kubernetes API using JSON over HTTP, which provides both the internal and external interface to Kubernetes. The API server processes, validates REST requests, and updates the state of the API objects in etcd, thereby allowing clients to configure workloads and containers across worker nodes. The API server uses etcd's *watch API* to monitor the cluster, roll out critical configuration changes, or restore any divergences of the state of the cluster back to the desired state as declared in etcd. 

*Nodes*
A node also known as worker, is a machine where containers/workloads are deployed. Every node in the cluster must run a container runtime, as well as the below-mentioned components..