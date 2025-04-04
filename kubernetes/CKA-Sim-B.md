# Question 1 | DNS / FQDN / Headless Service
The Deployment controller in Namespace lima-control communicates with various cluster internal endpoints by using their DNS FQDN values.

Update the ConfigMap used by the Deployment with the correct FQDN values for:

    DNS_1: Service kubernetes in Namespace default
    DNS_2: Headless Service department in Namespace lima-workload
    DNS_3: Pod section100 in Namespace lima-workload. It should work even if the Pod IP changes
    DNS_4: A Pod with IP 1.2.3.4 in Namespace kube-system

Ensure the Deployment works with the updated values.

## Answer
k -n lima-control exec -it controller-586d6657-gdmch -- sh

#nslookup kubernetes.default.svc.cluster.local
#nslookup department.lima-workload.svc.cluster.local
#nslookup section100.section.lima-workload.svc.cluster.local

kubectl -n lima-workload edit pod section100
spec:
  hostname: section100  # set hostname
  subdomain: section    # set subdomain to same name as service

#nslookup 1-2-3-4.kube-system.pod.cluster.local

k -n lima-control edit cm control-config
data:
  DNS_1: kubernetes.default.svc.cluster.local                  # UPDATE
  DNS_2: department.lima-workload.svc.cluster.local            # UPDATE
  DNS_3: section100.section.lima-workload.svc.cluster.local    # UPDATE
  DNS_4: 1-2-3-4.kube-system.pod.cluster.local                 # UPDATE

# Question 2 | Create a Static Pod and Service
Create a Static Pod named my-static-pod in Namespace default on the controlplane node. It should be of image nginx:1-alpine and have resource requests for 10m CPU and 20Mi memory.

Create a NodePort Service named static-pod-service which exposes that static Pod on port 80.

## Answer
k run my-static-pod --image=nginx:1-alpine -o yaml --dry-run=client > my-static-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-static-pod
  name: my-static-pod
spec:
  containers:
  - image: nginx:1-alpine
    name: my-static-pod
    resources:
      requests:
        cpu: 10m
        memory: 20Mi
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

k expose pod my-static-pod-cka2560 --name static-pod-service --type=NodePort --port 80

# Question 3 | Kubelet client/server cert info
Node cka5248-node1 has been added to the cluster using kubeadm and TLS bootstrapping.

Find the Issuer and Extended Key Usage values on cka5248-node1 for:
    Kubelet Client Certificate, the one used for outgoing connections to the kube-apiserver
    Kubelet Server Certificate, the one used for incoming connections from the kube-apiserver

Write the information into file /opt/course/3/certificate-info.txt.

## Answer
find /var/lib/kubelet/pki

openssl x509 -noout -text -in /var/lib/kubelet/pki/kubelet-client-current.pem | grep Issuer
openssl x509 -noout -text -in /var/lib/kubelet/pki/kubelet-client-current.pem | grep "Extended Key Usage" -A1

openssl x509 -noout -text -in /var/lib/kubelet/pki/kubelet.crt | grep Issuer
openssl x509 -noout -text -in /var/lib/kubelet/pki/kubelet.crt | grep "Extended Key Usage" -A1

### cka5248:/opt/course/3/certificate-info.txt
Issuer: CN = kubernetes
X509v3 Extended Key Usage: TLS Web Client Authentication
Issuer: CN = cka5248-node1-ca@1730211854
X509v3 Extended Key Usage: TLS Web Server Authentication

# Question 4 | Pod Ready if Service is reachable
Do the following in Namespace default:

    Create a Pod named ready-if-service-ready of image nginx:1-alpine
    Configure a LivenessProbe which simply executes command true
    Configure a ReadinessProbe which does check if the url http://service-am-i-ready:80 is reachable, you can use wget -T2 -O- http://service-am-i-ready:80 for this
    Start the Pod and confirm it isn't ready because of the ReadinessProbe.

Then:
    Create a second Pod named am-i-ready of image nginx:1-alpine with label id: cross-server-ready
    The already existing Service service-am-i-ready should now have that second Pod as endpoint
    Now the first Pod should be in ready state, check that.

## Answer
k run ready-if-service-ready --image=nginx:1-alpine --dry-run=client -o yaml > 4_pod1.yaml

    livenessProbe:                                      # add from here
      exec:
        command:
        - 'true'
    readinessProbe:
      exec:
        command:
        - sh
        - -c
        - 'wget -T2 -O- http://service-am-i-ready:80'   # to here

k run am-i-ready --image=nginx:1-alpine --labels="id=cross-server-ready"

# Question 5 | Kubectl sorting
Create two bash script files which use kubectl sorting to:

    1. Write a command into /opt/course/5/find_pods.sh which lists all Pods in all Namespaces sorted by their AGE (metadata.creationTimestamp)
    2. Write a command into /opt/course/5/find_pods_uid.sh which lists all Pods in all Namespaces sorted by field metadata.uid

## Answer 
kubectl get pod -A --sort-by=.metadata.creationTimestamp
kubectl get pod -A --sort-by=.metadata.uid

# Question 6 | Fix Kubelet
There seems to be an issue with the kubelet on controlplane node cka1024, it's not running.

Fix the kubelet and confirm that the node is available in Ready state.
Create a Pod called success in default Namespace of image nginx:1-alpine.

## Answer
Well, there we have it, wrong path specified in the config file. We go ahead and correct the path in file /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

whereis kubelet
kubelet: /usr/bin/kubelet

# Question 7 | Etcd Operations
You have been tasked to perform the following etcd operations:

    Run etcd --version and store the output at /opt/course/7/etcd-version
    Make a snapshot of etcd and save it at /opt/course/7/etcd-snapshot.db

## Answer
k -n kube-system exec etcd-cka2560 -- etcd --version

ETCDCTL_API=3 etcdctl snapshot save /opt/course/7/etcd-snapshot.db \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--cert /etc/kubernetes/pki/etcd/server.crt \
--key /etc/kubernetes/pki/etcd/server.key

# Question 8 | Get Controlplane Information
Check how the controlplane components kubelet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the controlplane node.

Also find out the name of the DNS application and how it's started/installed in the cluster.
Write your findings into file /opt/course/8/controlplane-components.txt

## Answer
kubelet: process
kube-apiserver: static-pod
kube-scheduler: static-pod
kube-controller-manager: static-pod
etcd: static-pod
dns: pod coredns

# Question 9 | Kill Scheduler, Manual Scheduling
Temporarily stop the kube-scheduler, this means in a way that you can start it again afterwards.

Create a single Pod named manual-schedule of image httpd:2-alpine, confirm it's created but not scheduled on any node.

Now you're the scheduler and have all its power, manually schedule that Pod on node cka5248. Make sure it's running.

Start the kube-scheduler again and confirm it's running correctly by creating a second Pod named manual-schedule2 of image httpd:2-alpine and check if it's running on cka5248-node1.

## Answer
mv kube-scheduler.yaml ..

 k run manual-schedule --image=httpd:2-alpine

 spec:
  nodeName: cka5248       # ADD the controlplane node name

mv ../kube-scheduler.yaml .

k run manual-schedule2 --image=httpd:2-alpine

# Question 10 | PV PVC Dynamic Provisioning
There is a backup Job which needs to be adjusted to use a PVC to store backups.

Create a StorageClass named local-backup which uses provisioner: rancher.io/local-path and volumeBindingMode: WaitForFirstConsumer. To prevent possible data loss the StorageClass should keep a PV retained even if a bound PVC is deleted.

Adjust the Job at /opt/course/10/backup.yaml to use a PVC which request 50Mi storage and uses the new StorageClass.

Deploy your changes, verify the Job completed once and the PVC was bound to a newly created PV.

## Answer

# Question 11 | Create Secret and mount into Pod
Create Namespace secret and implement the following in it:

    Create Pod secret-pod with image busybox:1. It should be kept running by executing sleep 1d or something similar

    Create the existing Secret /opt/course/11/secret1.yaml and mount it readonly into the Pod at /tmp/secret1

    Create a new Secret called secret2 which should contain user=user1 and pass=1234. These entries should be available inside the Pod's container as environment variables APP_USER and APP_PASS

## Answer
k create ns secret

cp /opt/course/11/secret1.yaml 11_secret1.yaml

k -n secret create secret generic secret2 --from-literal=user=user1 --from-literal=pass=1234

k -n secret run secret-pod --image=busybox:1 --dry-run=client -o yaml -- sh -c "sleep 1d" > 11.yaml

    env:                                  # add
    - name: APP_USER                      # add
      valueFrom:                          # add
        secretKeyRef:                     # add
          name: secret2                   # add
          key: user                       # add
    - name: APP_PASS                      # add
      valueFrom:                          # add
        secretKeyRef:                     # add
          name: secret2                   # add
          key: pass                       # add
    volumeMounts:                         # add
    - name: secret1                       # add
      mountPath: /tmp/secret1             # add
      readOnly: true                      # add
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:                                # add
  - name: secret1                         # add
    secret:                               # add
      secretName: secret1                 # add


# Question 12 | Schedule Pod on Controlplane Nodes
Create a Pod of image httpd:2-alpine in Namespace default.

The Pod should be named pod1 and the container should be named pod1-container.

This Pod should only be scheduled on controlplane nodes.

Do not add new labels to any nodes.

## Answer
k run pod1 --image=httpd:2-alpine --dry-run=client -o yaml > 12.yaml

spec:
  containers:
  - image: httpd:2-alpine
    name: pod1-container                       # change
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  tolerations:                                 # add
  - effect: NoSchedule                         # add
    key: node-role.kubernetes.io/control-plane # add
  nodeSelector:                                # add
    node-role.kubernetes.io/control-plane: ""  # add

# Question 13 | Multi Containers and Pod shared Volume
Create a Pod with multiple containers named multi-container-playground in Namespace default:

    It should have a volume attached and mounted into each container. The volume shouldn't be persisted or shared with other Pods

    Container c1 with image nginx:1-alpine should have the name of the node where its Pod is running on available as environment variable MY_NODE_NAME

    Container c2 with image busybox:1 should write the output of the date command every second in the shared volume into file date.log. You can use while true; do date >> /your/vol/path/date.log; sleep 1; done for this.

    Container c3 with image busybox:1 should constantly write the content of file date.log from the shared volume to stdout. You can use tail -f /your/vol/path/date.log for this.

## Answer
k run multi-container-playground --image=nginx:1-alpine --dry-run=client -o yaml > 13.yaml

spec:
  containers:
  - image: nginx:1-alpine
    name: c1                                                                      # change
    resources: {}
    env:                                                                          # add
    - name: MY_NODE_NAME                                                          # add
      valueFrom:                                                                  # add
        fieldRef:                                                                 # add
          fieldPath: spec.nodeName                                                # add
    volumeMounts:                                                                 # add
    - name: vol                                                                   # add
      mountPath: /vol                                                             # add
  - image: busybox:1                                                              # add
    name: c2                                                                      # add
    command: ["sh", "-c", "while true; do date >> /vol/date.log; sleep 1; done"]  # add
    volumeMounts:                                                                 # add
    - name: vol                                                                   # add
      mountPath: /vol                                                             # add
  - image: busybox:1                                                              # add
    name: c3                                                                      # add
    command: ["sh", "-c", "tail -f /vol/date.log"]                                # add
    volumeMounts:                                                                 # add
    - name: vol                                                                   # add
      mountPath: /vol                                                             # add
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:                                                                        # add
    - name: vol                                                                   # add
      emptyDir: {}                                                                # add

# Question 14 | Find out Cluster Information | 2 of 5
You're ask to find out following information about the cluster:

    How many controlplane nodes are available?
    How many worker nodes are available?
    What is the Service CIDR?
    Which Networking (or CNI Plugin) is configured and where is its config file?
    Which suffix will static pods have that run on cka8448?

Write your answers into file /opt/course/14/cluster-info, structured like this:

### /opt/course/14/cluster-info
1. 2. 1, 0
3. cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep range
4.  find /etc/cni/net.d/
5. k get pods -A

### How many controlplane nodes are available?
1: 1
### How many worker nodes are available?
2: 0
### What is the Service CIDR?
3: 10.96.0.0/12
### Which Networking (or CNI Plugin) is configured and where is its config file?
4: Weave, /etc/cni/net.d/10-weave.conflist
### Which suffix will static pods have that run on cka8448?
5: -cka8448

# Question 15 | Cluster Event Logging
    Write a kubectl command into /opt/course/15/cluster_events.sh which shows the latest events in the whole cluster, ordered by time (metadata.creationTimestamp)

    Delete the kube-proxy Pod and write the events this caused into /opt/course/15/pod_kill.log on cka6016

    Manually kill the containerd container of the kube-proxy Pod and write the events into /opt/course/15/container_kill.log

## Answer
kubectl get events -A --sort-by=.metadata.creationTimestamp
sh /opt/course/15/cluster_events.sh

k -n kube-system get pod -l k8s-app=kube-proxy -owide
sh /opt/course/15/cluster_events.sh

crictl ps | grep kube-proxy
crictl rm --force 2fd052f1fcf78
sh /opt/course/15/cluster_events.sh

# Question 16 | Namespaces and Api Resources
Write the names of all namespaced Kubernetes resources (like Pod, Secret, ConfigMap...) into /opt/course/16/resources.txt.

Find the project-* Namespace with the highest number of Roles defined in it and write its name and amount of Roles into /opt/course/16/crowded-namespace.txt.

## Answer
k api-resources --namespaced -o name > /opt/course/16/resources.txt

k -n project-jinan get role --no-headers | wc -l
k -n project-miami get role --no-headers | wc -l
k -n project-melbourne get role --no-headers | wc -l

# Question 17 | Operator, CRDs, RBAC, Kustomize
There is Kustomize config available at /opt/course/17/operator. It installs an operator which works with different CRDs. It has been deployed like this:

kubectl kustomize /opt/course/17/operator/prod | kubectl apply -f -

Perform the following changes in the Kustomize base config:

    The operator needs to list certain CRDs. Check the logs to find out which ones and adjust the permissions for Role operator-role
    Add a new Student resource called student4 with any name and description

Deploy your Kustomize config changes to prod.

## Answer
k kustomize base
k kustomize prod

k -n operator-prod logs operator-7f4f58d4d9-v6ftw

k -n operator-prod create role operator-role --verb list --resource student --resource class -oyaml --dry-run=client
vim base/rbac.yaml

kubectl kustomize /opt/course/17/operator/prod | kubectl apply -f -

vim base/students.yaml

kubectl kustomize /opt/course/17/operator/prod | kubectl apply -f -