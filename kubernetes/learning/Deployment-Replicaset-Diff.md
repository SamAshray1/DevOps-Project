**ReplicationController**, **ReplicaSet**, and **Deployment** all help manage the number of running pod replicas, ensuring availability and scalability.

### 1. **ReplicationController (RC)**
- The **oldest** method for managing pod replicas.
- Ensures a specified number of pod replicas are running at all times.
- If a pod crashes, the ReplicationController replaces it.
- **Limitation**: Uses exact **pod labels**, making updates and rolling deployments difficult.

✅ **When to Use?**  
- Rarely used today (deprecated in favor of ReplicaSet & Deployment).

---

### 2. **ReplicaSet (RS)**
- A newer version of ReplicationController with **better label selection**.
- Uses **label selectors** to manage pods efficiently.
- Supports **rolling updates**, but lacks a native way to update pod templates.

✅ **When to Use?**  
- Used internally by **Deployments** (not typically used directly).
- If you don’t need Deployment’s features (like rolling updates), you can use it.

---

### 3. **Deployment**
- The **recommended** way to manage pod replicas.
- Uses **ReplicaSets under the hood**.
- Provides **rolling updates and rollbacks**.
- Allows **declarative updates** to pod configurations.
- Supports **history tracking** (so you can revert to a previous version).
- Enables **scaling** up/down efficiently.

✅ **When to Use?**  
- **Always**, unless you have a very specific reason to use just a ReplicaSet.


### 🔥 **Summary**
| Feature           | ReplicationController | ReplicaSet | Deployment |
|------------------|----------------------|------------|------------|
| Ensures pod count |          ✅         | ✅        | ✅         |
| Uses label selectors |       ✅         | ✅ (More advanced) | ✅ |
| Rolling updates   |          ❌         | ❌         | ✅         |
| Rollbacks        |           ❌         | ❌         | ✅         |
| Declarative updates |        ❌          | ❌        | ✅         |
| History tracking |           ❌          | ❌        | ✅          |
| Recommended?      |          ❌ Deprecated | ❌ Only for specific cases | ✅ Always |
