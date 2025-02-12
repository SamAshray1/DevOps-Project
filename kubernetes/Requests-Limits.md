##  Requests and Limits

Requests: The minimum CPU and memory that a container is guaranteed. The scheduler uses this to decide where to place the pod.

Limits: The maximum CPU and memory a container can use. If exceeded, the container may be throttled (CPU) or killed (memory).

Why Use Requests and Limits?

    Efficient resource allocation: Ensures workloads get the necessary resources.
    Prevents resource starvation: Stops one pod from consuming too much CPU/memory.
    Avoids out-of-memory (OOM) kills: Containers exceeding memory limits are killed.
    Helps Kubernetes scheduler: Ensures pods are placed on suitable nodes.

⚠️ Key Considerations

✅ CPU Throttling: If a pod exceeds its CPU limit, Kubernetes throttles it (delays execution).
✅ Memory Kills: If a pod exceeds its memory limit, it is terminated (OOMKilled).
✅ No Limits = No Boundaries: If you don’t set limits, a pod can consume all available resources.
✅ Requests Affect Scheduling: The Kubernetes scheduler places pods based on requests, not limits.
✅ Resource Overcommitment: Nodes can schedule more pods than their total resources if limits are not enforced.