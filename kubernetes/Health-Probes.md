## Health Probes Day 9

# Liveness
The kubelet uses liveness probes to know when to restart a container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. 

# Readiness
The kubelet uses readiness probes to know when a container is ready to start accepting traffic. One use of this signal is to control which Pods are used as backends for Services. A Pod is considered ready when its Ready condition is true. When a Pod is not ready, it is removed from Service load balancers. A Pod's Ready condition is false when its Node's Ready condition is not true, when one of the Pod's readinessGates is false, or when at least one of its containers is not ready.

# Startup
The kubelet uses startup probes to know when a container application has started. If such a probe is configured, liveness and readiness probes do not start until it succeeds, making sure those probes don't interfere with the application startup. This can be used to adopt liveness checks on slow starting containers, avoiding them getting killed by the kubelet before they are up and running.