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

*kube-scheduler*
Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.

Factors taken into account for scheduling decisions include: individual and collective resource requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, and deadlines.

*kube-controller-manager*
Control plane component that runs controller processes. Runs controllers to implement Kubernetes API behavior.

Logically, each controller is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.

There are many different types of controllers. Some examples of them are:

    Node controller: Responsible for noticing and responding when nodes go down.
    Job controller: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
    EndpointSlice controller: Populates EndpointSlice objects (to provide a link between Services and Pods).
    ServiceAccount controller: Create default ServiceAccounts for new namespaces.

The above is not an exhaustive list

*Nodes*
A node also known as worker, is a machine where containers/workloads are deployed. Every node in the cluster must run a container runtime, as well as the below-mentioned components..

*kubelet*
An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod.

The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy. The kubelet doesn't manage containers which were not created by Kubernetes.

*Container runtime*
A fundamental component that empowers Kubernetes to run containers effectively. It is responsible for managing the execution and lifecycle of containers within the Kubernetes environment.

*kube-proxy (optional)*
kube-proxy is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept.

kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster.