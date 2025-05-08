https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/

Step 1: Backup etcd
ETCDCTL_API=3 etcdctl snapshot save PATH \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

Step 2: Restore etcd
ETCDCTL_API=3 etcdctl snapshot restore PATH \
  --data-dir=PATH 

Step 3: Reconfigure the etcd Pod to use the Restored Data
sudo vi /etc/kubernetes/manifests/etcd.yaml

- --data-dir=/root/default.etcd

Step 4: Restart the etcd Pod
sudo systemctl restart kubelet

Step 5: Verify etcd is Running
kubectl get pods -n kube-system | grep etcd

ETCDCTL_API=3 etcdctl endpoint health \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
