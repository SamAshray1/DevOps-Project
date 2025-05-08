# **Pod Admission & HA Control Plane for CKA 2025**  

Both **Pod Admission** and **High Availability (HA) Control Plane** are crucial topics for the **Certified Kubernetes Administrator (CKA) 2025** exam. Below is an in-depth explanation.

---

## **1. Pod Admission in Kubernetes**
Pod Admission is the process where a pod is evaluated before it is scheduled on a node. Several components **validate, mutate, and approve** pod requests before execution.

### **Pod Admission Workflow**
1. **User submits a pod request** (`kubectl apply -f pod.yaml`).
2. **API Server receives the request** and performs initial validation.
3. **Admission Controllers process the request**:
   - **Mutating Admission Webhooks** (Modify pod specs if needed)
   - **Validating Admission Webhooks** (Reject/approve based on security rules)
4. **Scheduler assigns a node**.
5. **Kubelet pulls the container image and starts the pod**.

---

### **2. Admission Controllers**
Admission controllers enforce security, policy, and resource rules **before** a pod runs.

#### **Important Admission Controllers for CKA 2025**
| Admission Controller | Purpose |
|----------------------|---------|
| **NamespaceLifecycle** | Blocks creation of objects in deleted namespaces |
| **LimitRanger** | Enforces CPU/memory limits if not set |
| **ResourceQuota** | Ensures namespace quotas are not exceeded |
| **PodSecurity** | Enforces security policies (e.g., non-root users) |
| **MutatingAdmissionWebhook** | Modifies pods before creation (e.g., inject sidecars) |
| **ValidatingAdmissionWebhook** | Rejects invalid pod configurations |
| **NodeRestriction** | Prevents kubelets from modifying other nodes' data |

### **3. Example: Validating Admission Webhook**
- A webhook that blocks pods running as root.

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: deny-root-pods
webhooks:
  - name: deny-root.example.com
    rules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
        operations: ["CREATE"]
    clientConfig:
      service:
        name: validation-service
        namespace: default
        path: "/validate"
```

**💡 Key takeaway:** Admission controllers **prevent bad configurations** before a pod runs.

---

## **4. High Availability (HA) Control Plane**
An **HA control plane** ensures that Kubernetes remains available even if some components fail. This is **critical for production clusters and CKA 2025.**

### **5. Components of HA Control Plane**
| Component | Purpose |
|-----------|---------|
| **API Server (`kube-apiserver`)** | Handles all Kubernetes requests |
| **Scheduler (`kube-scheduler`)** | Assigns pods to nodes |
| **Controller Manager (`kube-controller-manager`)** | Ensures cluster state matches the desired state |
| **etcd** | Stores all cluster data |
| **Kubelet** | Runs on worker nodes, manages pods |
| **Kube-Proxy** | Handles networking and load balancing |

---

### **6. Setting Up an HA Control Plane**
An **HA Kubernetes cluster** typically has:
- **Multiple API Server instances** running behind a **load balancer**.
- **Multiple etcd nodes** for fault tolerance.
- **Multiple control plane nodes** (Scheduler & Controller Manager).
- **Worker nodes** that run applications.

### **7. HA Control Plane Architecture**
```
                      +--------------------+
                      |  Load Balancer     |
                      +--------------------+
                               |
        +--------------------------------------+
        | API Server | API Server | API Server |
        +--------------------------------------+
                     | | |
          +---------------------------+
          |    etcd Cluster (3-5 nodes) |
          +---------------------------+
               |               |
         +-----------+   +-----------+
         | Worker 1  |   | Worker 2  |
         +-----------+   +-----------+
```

### **8. Key Considerations for HA**
| Factor | Best Practice |
|--------|--------------|
| **Load Balancer** | Use HAProxy, Nginx, or AWS ELB |
| **etcd** | Deploy 3+ nodes for quorum |
| **API Server** | Run multiple instances behind a load balancer |
| **Controller & Scheduler** | Run multiple instances, but **only one should be active** (leader election) |
| **Worker Nodes** | Should connect to multiple API servers |

---

### **9. Example: Setting Up an HA Control Plane**
#### **1. Deploy Multiple API Servers**
Modify `kubeadm-config.yaml` to use multiple API server endpoints.

```yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
controlPlaneEndpoint: "k8s-lb.example.com:6443"
apiServer:
  certSANs:
    - "k8s-lb.example.com"
    - "api-1.example.com"
    - "api-2.example.com"
etcd:
  external:
    endpoints:
      - https://etcd-1.example.com:2379
      - https://etcd-2.example.com:2379
      - https://etcd-3.example.com:2379
```

#### **2. Deploy Highly Available etcd**
```bash
etcd --name etcd-1 \
     --initial-advertise-peer-urls https://etcd-1.example.com:2380 \
     --listen-peer-urls https://0.0.0.0:2380 \
     --listen-client-urls https://0.0.0.0:2379 \
     --initial-cluster etcd-1=https://etcd-1.example.com:2380,etcd-2=https://etcd-2.example.com:2380
```

#### **3. Configure Load Balancer for API Server**
If using **HAProxy**:
```haproxy
frontend k8s-api
    bind *:6443
    default_backend k8s-api-nodes

backend k8s-api-nodes
    balance roundrobin
    server api-1 api-1.example.com:6443 check
    server api-2 api-2.example.com:6443 check
    server api-3 api-3.example.com:6443 check
```

---

### **10. HA Control Plane Failover**
| Failure Scenario | Effect | Recovery |
|-----------------|--------|----------|
| **1 API Server fails** | Other API servers continue handling requests | Load balancer redirects traffic |
| **1 etcd node fails** | Cluster continues if a quorum remains | Replace etcd node |
| **1 control plane node fails** | Leader election selects a new leader | Restart the node or replace it |

---

## **11. Summary**
| Topic | Key Points |
|-------|-----------|
| **Pod Admission** | Uses Admission Controllers (Mutating & Validating) to approve or deny pod creation |
| **HA Control Plane** | Uses multiple API servers, load balancers, and etcd to ensure high availability |
| **Admission Controllers** | Enforce security, resource limits, and policies |
| **Load Balancer** | Distributes API server requests |
| **etcd Redundancy** | Ensures Kubernetes state remains intact |

Mastering **Pod Admission** and **HA Control Plane** will help you pass **CKA 2025** and manage production-grade Kubernetes clusters! 🚀