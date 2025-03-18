# Project Level 4

Install Prometheus via Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


Create a namespace:
kubectl create namespace monitoring

Install kube-prometheus-stack:
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring

  kubectl get pods -n monitoring



### **📌 Monitoring an EKS Cluster (CPU, Memory, HTTPS Requests) Using an EC2 Grafana Instance**  
We will **set up an EC2 instance** with **Grafana, Prometheus, and kube-prometheus-stack** to monitor an EKS cluster.

---

# **🛠️ Steps Overview**
1️⃣ **Provision an EC2 instance** for Grafana  
2️⃣ **Install & configure Grafana**  
3️⃣ **Deploy Prometheus on EKS**  
4️⃣ **Configure Prometheus to scrape EKS metrics**  
5️⃣ **Connect EC2 Grafana to Prometheus in EKS**  
6️⃣ **Verify Dashboards**  

---

# **🚀 Step 1: Provision an EC2 Instance for Grafana**
### **Create an EC2 Instance**
1. **Login to AWS Console** and go to **EC2**.
2. Click **Launch Instance**.
3. Choose an **Ubuntu 22.04 LTS** AMI.
4. Instance type: **t3.medium** (at least 4GB RAM for Grafana).
5. Set up **security group rules**:
   - **Allow inbound rules** for:
     - SSH (`22`) → Your IP
     - HTTP (`80`) → 0.0.0.0/0
     - HTTPS (`443`) → 0.0.0.0/0
     - Grafana (`3000`) → 0.0.0.0/0
6. Attach an **IAM Role** (if using IRSA) with policies:
   - `AmazonEC2ReadOnlyAccess`
   - `CloudWatchReadOnlyAccess`
7. Click **Launch**.

---

# **🚀 Step 2: Install & Configure Grafana on EC2**
### **Connect to EC2 & Install Grafana**
SSH into your EC2 instance:
```bash
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
```
Install dependencies:
```bash
sudo apt update && sudo apt install -y software-properties-common
```
Add Grafana repo & install:
```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update && sudo apt install -y grafana
```
Start and enable Grafana:
```bash
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```
Check status:
```bash
sudo systemctl status grafana-server
```
🔹 **Access Grafana:**  
Go to **`http://<EC2_PUBLIC_IP>:3000`**  
(Default login: `admin / admin`)

---

# **🚀 Step 3: Deploy Prometheus on EKS**
### **Install Prometheus via Helm**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
Create a namespace:
```bash
kubectl create namespace monitoring
```
Install **kube-prometheus-stack**:
```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring
```
Verify:
```bash
kubectl get pods -n monitoring
```

---

# **🚀 Step 4: Configure Prometheus to Scrape EKS Metrics**
### **Expose Prometheus as a Service**
1. Edit the `prometheus-kube-prometheus-prometheus` service:
   ```bash
   kubectl edit svc prometheus-kube-prometheus-prometheus -n monitoring
   ```
2. Change `ClusterIP` to `NodePort`:
   ```yaml
   spec:
     type: NodePort
   ```
3. Get the **NodePort**:
   ```bash
   kubectl get svc -n monitoring
   ```
   Look for **`prometheus-kube-prometheus-prometheus`**, note the port.

4. Get a worker node IP:
   ```bash
   kubectl get nodes -o wide
   ```
5. **Test Prometheus Endpoint**:  
   Open in browser:
   ```
   http://<WORKER_NODE_IP>:<PROMETHEUS_NODEPORT>
   ```

---

# **🚀 Step 5: Connect EC2 Grafana to Prometheus in EKS**
### **Add Prometheus as a Data Source**
1. Login to **Grafana** (`http://<EC2_PUBLIC_IP>:3000`).
2. Go to **Configuration > Data Sources**.
3. Click **"Add data source"**.
4. Select **Prometheus**.
5. Enter Prometheus URL:
   ```
   http://<WORKER_NODE_IP>:<PROMETHEUS_NODEPORT>
   ```
6. Click **"Save & Test"** → It should connect successfully!

---

# **🚀 Step 6: Add Dashboards for CPU, Memory, HTTPS Requests**
### **Import Prebuilt Dashboards**
1. Go to **Grafana > Dashboards**.
2. Click **Import**.
3. Use the following dashboard IDs:
   - **EKS Cluster Monitoring**: `11074`
   - **Node Exporter (CPU, Memory, Disk)**: `1860`
   - **Kubernetes Cluster Monitoring**: `6417`
   - **Nginx HTTPS Requests (if applicable)**: `9614`
4. Click **Load**, then select your **Prometheus data source**.

---

# **✅ Done! Now You Can Monitor EKS from EC2 Grafana**
- **CPU & Memory**: Shown in the `Node Exporter` dashboard.
- **HTTPS Requests**:
  - If using **Nginx Ingress**, install Prometheus metrics:
    ```bash
    helm install nginx-ingress stable/nginx-ingress --set controller.metrics.enabled=true
    ```
  - Then scrape metrics using Prometheus.

Let me know if you need any clarifications! 🚀🔥