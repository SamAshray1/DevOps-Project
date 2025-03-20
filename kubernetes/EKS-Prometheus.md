### **Storage in EKS Clusters, Pods, and Grafana**  

In Amazon **EKS (Elastic Kubernetes Service)**, storage depends on the workload’s requirements. Let’s break it down:

---

## **1. Storage of EKS Cluster and Its Pods**
By default, Kubernetes Pods are **ephemeral**, meaning their storage is lost when a Pod is restarted. However, **persistent storage** can be used based on the requirement:

### **Types of Storage in EKS**  
| Storage Type | Description | Use Case |
|-------------|-------------|-----------|
| **Ephemeral Storage** | Uses the node’s local disk (`/var/lib/kubelet/`). Data is lost if the Pod is deleted or moved. | Temporary logs, caches. |
| **EBS (Elastic Block Store)** | Block storage attached to worker nodes. Can be dynamically provisioned using a **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)**. | Stateful applications (databases, persistent workloads). |
| **EFS (Elastic File System)** | A shared file system across multiple Pods and nodes. | Shared storage between Pods. |
| **S3 (Simple Storage Service)** | Object storage, not directly mounted to Pods but used for storing logs, backups, and large datasets. | Storing logs, backups, ML datasets. |

📌 **Example: Persistent Volume for EBS in EKS**  
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: gp2  # EBS Storage Class
```
This ensures data **persists even if the Pod is restarted**.

---

## **2. Storage for Grafana Data**
Grafana itself is **stateless**, meaning **it does not store data**. Instead, it pulls metrics from **data sources** like Prometheus, Loki, or InfluxDB.

### **Ways to Store Grafana Data**  
✅ **Dashboards & Configurations:** Stored in a **database** (PostgreSQL, MySQL, or SQLite). If running in Kubernetes, it should use **Persistent Storage** like EBS.  
✅ **Metrics & Logs:** Grafana does **not store metrics**; it queries from **Prometheus**, **Loki**, **CloudWatch**, or other data sources.  
✅ **Alerts & Annotations:** Saved in the Grafana database (PostgreSQL/MySQL) or backend storage.  

📌 **Example: Grafana PVC for Persistent Data**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
```
This ensures **Grafana configurations and dashboards are saved** even after a restart.

---

## **3. Scheduling Data Retention for 60 Days**
To **automatically delete old data after 60 days**, we need retention policies.

### **For Prometheus (Metrics Storage)**
Prometheus stores metrics locally on disk or remotely. To set **retention to 60 days**, configure `--storage.tsdb.retention.time`:

📌 **Example: Helm Values for Prometheus**
```yaml
server:
  extraArgs:
    - "--storage.tsdb.retention.time=60d"
```
This ensures **metrics older than 60 days** are automatically deleted.

### **For Loki (Log Storage)**
Loki, a log aggregation system used with Grafana, supports log retention policies.

📌 **Example: Loki Config for 60 Days Retention**
```yaml
limits_config:
  retention_period: 60d
```

### **For S3 (External Log Storage)**
If logs are stored in **Amazon S3**, you can set a **Lifecycle Policy** to delete objects after 60 days.

📌 **Example: S3 Lifecycle Rule**
```json
{
  "Rules": [
    {
      "ID": "DeleteOldLogs",
      "Prefix": "logs/",
      "Status": "Enabled",
      "Expiration": {
        "Days": 60
      }
    }
  ]
}
```

---

## **Summary**
| Storage | Where It’s Used | How to Retain for 60 Days |
|---------|----------------|---------------------------|
| **EBS** | Persistent data in EKS Pods | Set up **PVC** for storage. |
| **EFS** | Shared storage for Pods | Use EFS with **access policies**. |
| **S3** | Object storage for logs, backups | Apply **Lifecycle Policy** (delete after 60 days). |
| **Prometheus** | Stores **metrics** | Configure **`--storage.tsdb.retention.time=60d`**. |
| **Loki** | Stores **logs** | Set **retention_period: 60d** in Loki config. |
| **Grafana** | Stores dashboards, alerts | Use **PVC** for persistent database. |




### **Should You Manage Prometheus Metrics in Kubernetes?**  
Yes, managing **Prometheus metrics** is crucial, especially in a Kubernetes (EKS) environment, to **prevent excessive resource usage** and ensure **efficient querying**. Without proper management, Prometheus can:  
- Consume **high disk space** due to unbounded metric retention.  
- Overload queries, affecting performance.  
- Cause **slow dashboard loading** in Grafana.  

---

## **How to Manage Prometheus Metrics Efficiently?**  
### **1. Set a Data Retention Policy**
By default, Prometheus stores metrics **forever**, which is not ideal.  
You can **limit retention** to **60 days** (or less) using `--storage.tsdb.retention.time`.  

📌 **Example: Helm Values for Prometheus (60-day retention)**  
```yaml
server:
  extraArgs:
    - "--storage.tsdb.retention.time=60d"
```
If using a **Prometheus ConfigMap**, update the `args` section:
```yaml
- --storage.tsdb.retention.time=60d
```
🚀 **Best Practice:** Set retention **based on storage availability**. Many teams use **15 to 30 days**.

---

### **2. Enable Remote Storage for Long-Term Storage**
Prometheus stores data **locally**, which can cause **disk pressure**.  
You can **offload historical metrics** to an external backend like:  
✅ **Thanos** – Object storage-based scalable solution.  
✅ **Cortex** – Horizontally scalable storage backend.  
✅ **Amazon Managed Prometheus** – Fully managed AWS service.  
✅ **S3/GCS/BigQuery** – For long-term historical storage.  

📌 **Example: Configuring Remote Storage to Thanos**
```yaml
remote_write:
  - url: "http://thanos-receive.default.svc:10901/api/v1/receive"
```
This ensures **only recent data** is stored locally, reducing disk usage.

---

### **3. Drop Unnecessary High-Cardinality Metrics**
Some **metrics generate too many labels**, leading to **high memory usage**.  
You can **drop unused or noisy metrics** using `metric_relabel_configs`.

📌 **Example: Dropping Unnecessary Labels**  
```yaml
metric_relabel_configs:
  - source_labels: [pod]
    regex: ".*-test-.*"
    action: drop
```
This drops **metrics from test Pods**, saving storage.

🚀 **Best Practice:** Use PromQL queries like:  
```promql
count by (__name__)({__name__=~".+"})
```
to identify **metrics with the highest cardinality** and drop unnecessary ones.

---

### **4. Use Federation for Large Clusters**
If your **EKS cluster is large**, **one Prometheus instance may not be enough**.  
Use **federation** to scrape key metrics from multiple instances.  

📌 **Example: Federation Config**
```yaml
scrape_configs:
  - job_name: "federation"
    scrape_interval: 15s
    honor_labels: true
    metrics_path: "/federate"
    params:
      match[]:
        - '{job="kubelet"}'
    static_configs:
      - targets:
          - "prometheus-cluster1:9090"
          - "prometheus-cluster2:9090"
```
🚀 **Best Practice:** Use **Thanos/Cortex** instead of federation for very large clusters.

---

### **5. Use Compaction & Downsampling**
Prometheus stores **high-precision raw metrics**, which may not be needed for older data.  
- **Downsampling:** Reduces resolution for older data.  
- **Compaction:** Merges small blocks into fewer, larger blocks to save space.  

🚀 **Solution:** Use **Thanos Compact** to automatically downsample old data.  

---

### **6. Monitor Prometheus Itself**
Prometheus **scrapes itself**, but you should also monitor:  
✅ `prometheus_tsdb_head_series` → **Number of active series** (avoid >10M).  
✅ `prometheus_engine_query_duration_seconds` → **Query performance** (keep low).  
✅ `prometheus_http_requests_total` → **Scrape failures**.  

📌 **Example: Alert for High Memory Usage**
```yaml
- alert: PrometheusHighMemory
  expr: process_resident_memory_bytes > 4e+09
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Prometheus instance using high memory!"
```
🚀 **Best Practice:** Set alerts to **prevent crashes** due to high resource usage.

---

## **Final Recommendations**
| **Strategy**               | **Why?** | **How?** |
|---------------------------|---------|---------|
| **Limit retention (30-60 days)** | Prevents high disk usage | `--storage.tsdb.retention.time=30d` |
| **Use remote storage** | Offloads historical data | Thanos, Cortex, or AWS Managed Prometheus |
| **Drop high-cardinality metrics** | Reduces memory pressure | Use `metric_relabel_configs` |
| **Enable federation for scaling** | Distributes metric collection | Use `federation` in `scrape_configs` |
| **Monitor Prometheus itself** | Prevents slow queries | Use Grafana dashboards & alerts |