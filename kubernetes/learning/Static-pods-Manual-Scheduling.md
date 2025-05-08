## Static Pods

Path of the manifest yml files:
/etc/kubernetes/manifests

## Selectors and Labels

kubectl get pods --selector env=prod


### **What Are Static Pods in Kubernetes?**  
A **Static Pod** is a Pod managed directly by the **kubelet**, instead of the API Server. These Pods are mainly used to run **control plane components** on a node (e.g., API Server, Controller Manager, etcd) and are not managed by the Kubernetes scheduler.  

🚀 **Key Characteristics:**  
✅ **Created directly by kubelet** without an associated Deployment or ReplicaSet.  
✅ **Defined in a YAML file stored in a specific directory** on the node (e.g., `/etc/kubernetes/manifests/`).  
✅ **Not visible in `kubectl get deployments`** because they aren't managed by the API Server.  
✅ Kubelet automatically **restarts them** if they fail.  

---

### **What Monitors the Static Pod Manifest Folder?**  
The **kubelet** is responsible for:  
1. **Watching the manifest directory** (e.g., `/etc/kubernetes/manifests/`).  
2. **Detecting changes** (new, modified, or deleted static Pod YAML files).  
3. **Creating, updating, or deleting Pods** accordingly.  

🔥 **Key Difference from Regular Pods:**  
- Regular Pods are managed by the **API Server** and **Scheduler**.  
- Static Pods are **directly managed by the kubelet** and **do not go through the scheduler**.  
- Static Pods are **automatically mirrored** as read-only objects in the API Server (seen via `kubectl get pods -n kube-system`).  

---

### **Use Cases of Static Pods**
🔹 Bootstrapping a **Kubernetes control plane** (API Server, etcd, Controller Manager).  
🔹 Running **essential services** on a node before the cluster is fully operational.  
🔹 Ensuring critical workloads run **even if the API Server is down**.  

Would you like a real-world example of how static pods help in a **high availability setup**? 🚀