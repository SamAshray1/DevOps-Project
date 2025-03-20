### **Role of Kubelet in Kubernetes Nodes**  
The **kubelet** is an agent running on every node in a Kubernetes cluster, responsible for ensuring that containers in Pods are running as expected.  

#### **1. Kubelet in Worker Nodes**  
On worker nodes, the **kubelet** is responsible for:  
✅ **Registering the Node** with the control plane.  
✅ **Watching for assigned Pods** from the API Server.  
✅ **Ensuring Pods are running** as defined in their spec.  
✅ **Interacting with the container runtime** (Docker, containerd, CRI-O) to manage containers.  
✅ **Reporting node status** (CPU, memory, disk) back to the control plane.  
✅ **Managing liveness and readiness probes** for health checks.  

📌 **Example Workflow on a Worker Node:**  
1. A new Pod is scheduled to the node by the **kube-scheduler**.  
2. The kubelet sees the new Pod and starts containers using the container runtime.  
3. It continuously monitors the Pod’s health.  
4. If a container crashes, kubelet attempts to restart it.  
5. It updates the control plane with the Pod and Node status.  

---

### **2. Kubelet in Control Plane Nodes**  
On control plane nodes, kubelet plays a similar role but also manages control plane components:  
✅ Runs **API Server, Controller Manager, Scheduler, etcd** as static Pods.  
✅ Ensures control plane components are running and restarted if they fail.  

📌 **Key Difference:**  
- In worker nodes, kubelet ensures app **Pods** are running.  
- In control plane nodes, kubelet ensures **control plane components** are running.  

🚀 **Summary:**  
- Kubelet is critical for running and managing Pods.  
- It acts as the bridge between the **control plane** and the **container runtime**.  
- Without kubelet, nodes cannot participate in the cluster.  

Would you like a deep dive into kubelet logs or troubleshooting? 🚀