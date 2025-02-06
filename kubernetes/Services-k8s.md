## Services

What is a Service?

Expose an application running in your cluster behind a single outward-facing endpoint, even when the workload is split across multiple backends.
In Kubernetes, a Service is a method for exposing a network application that is running as one or more Pods in your cluster.

The Service abstraction enables this decoupling, where the frontend, need not be aware of the changes taking place in the backend, with regards to pod updates, etc. But can just refer to the endpoint of the service of backend, which will direct the traffic properly. (ingress).


## Service Types

In Kubernetes, there are several service types that define how a service is exposed and accessed within or outside the cluster. Here are the main ones:

1. **ClusterIP** (default):
   - Exposes the service on a cluster-internal IP. 
   - It’s only accessible within the Kubernetes cluster.
   - This is the default service type if none is specified.
   
2. **NodePort**:
   - Exposes the service on each node's IP at a static port (the NodePort).
   - Can be accessed externally by sending a request to `<NodeIP>:<NodePort>`.
   - This is often used when you need to expose a service externally but don't want to set up an Ingress controller.

3. **LoadBalancer**:
   - Exposes the service externally via a cloud provider's load balancer.
   - It automatically provisions an external IP address and routes traffic to the service.
   - Typically used in cloud environments like AWS, GCP, or Azure.

4. **ExternalName**:
   - Maps a service to a DNS name outside the cluster.
   - The DNS name can be an external service, and Kubernetes will forward requests to that DNS address.
   - This is useful for services that are external to the Kubernetes cluster but you want to access them like a native Kubernetes service.
