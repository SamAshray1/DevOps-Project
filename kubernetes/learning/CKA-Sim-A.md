# Question 1 | Contexts | 3 of 3
## You're asked to extract the following information out of kubeconfig file /opt/course/1/kubeconfig on cka9412:

###    Write all kubeconfig context names into /opt/course/1/contexts, one per line
        k --kubeconfig /opt/course/1/kubeconfig config get-contexts
        k --kubeconfig /opt/course/1/kubeconfig config get-contexts -oname > /opt/course/1/contexts

###    Write the name of the current context into /opt/course/1/current-context
        k --kubeconfig /opt/course/1/kubeconfig config current-context 
        k --kubeconfig /opt/course/1/kubeconfig config current-context > /opt/course/1/current-context

###    Write the client-certificate of user account-0027 base64-decoded into /opt/course/1/cert
        echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN2RE... | base64 -d > /opt/course/1/cert


# Question 2 | MinIO Operator, CRD Config, Helm Install | 3 of 4
## Install the MinIO Operator using Helm in Namespace minio. Then configure and create the Tenant CRD:

###    Create Namespace minio
        k create ns minio

###    Install Helm chart minio/operator into the new Namespace. The Helm Release should be called minio-operator
        helm repo list
        helm search repo
        helm -n minio install minio-operator minio/operator
        helm -n minio ls
        k -n minio get pod

###    Update the Tenant resource in /opt/course/2/minio-tenant.yaml to include enableSFTP: true under features
        vim /opt/course/2/minio-tenant.yaml
        enableSFTP: true                     # ADD

        We can see available fields for features like this:
        k describe crd tenant | grep -i feature -A 20

###    Create the Tenant resource from /opt/course/2/minio-tenant.yaml
        k -f /opt/course/2/minio-tenant.yaml apply
        k -n minio get tenant


# Question 3 | Scale down StatefulSet | 1 of 1
## There are two Pods named o3db-* in Namespace project-h800. The Project H800 management asked you to scale these down to one replica to save resources.

k -n project-h800 scale sts o3db --replicas 1
     
# Question 4 | Find Pods first to be terminated | 1 of 1
## Check all available Pods in the Namespace project-c13 and find the names of those that would probably be terminated first if the nodes run out of resources (cpu or memory).

Write the Pod names into /opt/course/4/pods-terminated-first.txt.

c13-3cc-runner-heavy-65588d7d6-djtv9map
c13-3cc-runner-heavy-65588d7d6-v8kf5map
c13-3cc-runner-heavy-65588d7d6-wwpb4map


# Question 5 | Kustomize configure HPA Autoscaler | 4 of 6
## Previously the application api-gateway used some external autoscaler which should now be replaced with a HorizontalPodAutoscaler (HPA). The application has been deployed to Namespaces api-gateway-staging and api-gateway-prod like this:

kubectl kustomize /opt/course/5/api-gateway/staging | kubectl apply -f -
kubectl kustomize /opt/course/5/api-gateway/prod | kubectl apply -f -

Using the Kustomize config at /opt/course/5/api-gateway do the following:
        cd /opt/course/5/api-gateway
        k kustomize base
        k kustomize staging
        k kustomize staging | kubectl diff -f -
        k kustomize prod
        k kustomize prod | kubectl diff -f -

###    Remove the ConfigMap horizontal-scaling-config completely
        We need to remove the ConfigMap from base, staging and prod because staging and prod both reference it as a patch. So we edit files base/api-gateway.yaml, staging/api-gateway.yaml and prod/api-gateway.yaml and remove the ConfigMap.
        k kustomize base
        k kustomize staging
        k kustomize prod

        k -n api-gateway-staging delete cm horizontal-scaling-config 
        k -n api-gateway-prod delete cm horizontal-scaling-config 

###    Add HPA named api-gateway for the Deployment api-gateway with min 2 and max 4 replicas. It should scale at 50% average CPU utilisation
        https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
        We're going to add the requested HPA into the base config file:
            # cka5774:/opt/course/5/api-gateway/base/api-gateway.yaml
                apiVersion: autoscaling/v2
                kind: HorizontalPodAutoscaler
                metadata:
                name: api-gateway
                spec:
                scaleTargetRef:
                    apiVersion: apps/v1
                    kind: Deployment
                    name: api-gateway
                minReplicas: 2
                maxReplicas: 4
                metrics:
                    - type: Resource
                    resource:
                        name: cpu
                        target:
                        type: Utilization
                        averageUtilization: 50

###    In prod the HPA should have max 6 replicas
        # cka5774:/opt/course/5/api-gateway/prod/api-gateway.yaml
        apiVersion: autoscaling/v2
        kind: HorizontalPodAutoscaler
        metadata:
        name: api-gateway
        spec:
        maxReplicas: 6

###    Apply your changes for staging and prod so they're reflected in the cluster
        k kustomize staging | kubectl diff -f -
        k kustomize staging | kubectl apply -f -


# Question 6 | Storage, PV, PVC, Pod volume | 6 of 6
Create a new PersistentVolume named safari-pv. It should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName defined.

Next create a new PersistentVolumeClaim in Namespace project-t230 named safari-pvc . It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new Deployment safari in Namespace project-t230 which mounts that volume at /tmp/safari-data. The Pods of that Deployment should be of image httpd:2-alpine.

# Question 7 | Node and Pod Resource Usage | 1 of 2
The metrics-server has been installed in the cluster. Write two bash scripts which use kubectl:

##     Script /opt/course/7/node.sh should show resource usage of Nodes
        kubectl top node
##    Script /opt/course/7/pod.sh should show resource usage of Pods and their containers
        kubectl top pod --containers=true

# Question 8 | Update Kubernetes Version and join cluster | 2 of 4
Your coworker notified you that node cka3962-node1 is running an older Kubernetes version and is not even part of the cluster yet.

###    Update the node's Kubernetes to the exact version of the controlplane
        k get node

        ssh cka3962-node1
        kubectl version
        kubelet --version
        kubeadm version
        (Above we can see that kubeadm is already installed in the exact needed version, otherwise we would need to install it using apt install kubeadm=1.32.1-1.1.)

        apt update
        apt show kubectl -a | grep 1.32
        apt install kubectl=1.32.1-1.1 kubelet=1.32.1-1.1
        kubelet --version
        service kubelet restart
        service kubelet status

###   Add the node to the cluster using kubeadm
        kubeadm token create --print-join-command

# Question 9 | Contact K8s Api from inside Pod | 1 of 2
## There is ServiceAccount secret-reader in Namespace project-swan. Create a Pod of image nginx:1-alpine named api-contact which uses this ServiceAccount.
    k run api-contact --image=nginx:1-alpine --dry-run=client -o yaml > 9.yaml
    namespace: project-swan             # add
    serviceAccountName: secret-reader   # add

### Exec into the Pod and use curl to manually query all Secrets from the Kubernetes Api.
    k -n project-swan exec api-contact -it -- sh\

    # curl https://kubernetes.default
    # curl -k https://kubernetes.default
    # curl -k https://kubernetes.default/api/v1/secrets

    # TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
    # curl -k https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

### Write the result into file /opt/course/9/result.json.
    # curl -k https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}" > result.json
    k -n project-swan exec api-contact -it -- cat result.json > /opt/course/9/result.json

### Connect via HTTPS with correct CA
    # CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    # curl --cacert ${CACERT} https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

# Question 10 | RBAC ServiceAccount Role RoleBinding | 6 of 6
# Question 11 | DaemonSet on all Nodes | 4 of 4
# Question 12 | Deployment on all Nodes | 11 of 11

# Question 13 | Gateway Api Ingress | 0 of 0
The team from Project r500 wants to replace their Ingress (networking.k8s.io) with a Gateway Api (gateway.networking.k8s.io) solution. The old Ingress is available at /opt/course/13/ingress.yaml.

Perform the following in Namespace project-r500 and for the already existing Gateway:

    Create a new HTTPRoute named traffic-director which replicates the routes from the old Ingress
    Extend the new HTTPRoute with path /auto which redirects to mobile if the User-Agent is exactly mobile and to desktop otherwise

The existing Gateway is reachable at http://r500.gateway:30080 which means your implementation should work for these commands:

curl r500.gateway:30080/desktop
curl r500.gateway:30080/mobile
curl r500.gateway:30080/auto -H "User-Agent: mobile" 
curl r500.gateway:30080/auto

# Question 14 | Check how long certificates are valid | 1 of 2
Perform some tasks on cluster certificates:

##    Check how long the kube-apiserver server certificate is valid using openssl or cfssl. Write the expiration date into /opt/course/14/expiration. Run the kubeadm command to list the expiration dates and confirm both methods show the same one
        find /etc/kubernetes/pki | grep apiserver
        openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep Validity -A2

        kubeadm certs check-expiration | grep apiserver

###    Write the kubeadm command that would renew the kube-apiserver certificate into /opt/course/14/kubeadm-renew-certs.sh
        kubeadm certs renew apiserver
 
# Question 15 | NetworkPolicy | 5 of 7
There was a security incident where an intruder was able to access the whole cluster from a single hacked backend Pod.

To prevent this create a NetworkPolicy called np-backend in Namespace project-snake. It should allow the backend-* Pods only to:

    Connect to db1-* Pods on port 1111

    Connect to db2-* Pods on port 2222

Use the app Pod labels in your policy.

### cka7968:/home/candidate/15_np.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-backend
  namespace: project-snake
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Egress                    # policy is only about Egress
  egress:
    -                           # first rule
      to:                           # first condition "to"
      - podSelector:
          matchLabels:
            app: db1
      ports:                        # second condition "port"
      - protocol: TCP
        port: 1111
    -                           # second rule
      to:                           # first condition "to"
      - podSelector:
          matchLabels:
            app: db2
      ports:                        # second condition "port"
      - protocol: TCP
        port: 2222

# Question 16 | Update CoreDNS Configuration | 0 of 3
The CoreDNS configuration in the cluster needs to be updated:

###   Make a backup of the existing configuration Yaml and store it at /opt/course/16/coredns_backup.yaml. You should be able to fast recover from the backup
        k -n kube-system get cm coredns -oyaml > /opt/course/16/coredns_backup.yaml

###    Update the CoreDNS configuration in the cluster so that DNS resolution for SERVICE.NAMESPACE.custom-domain will work exactly like and in addition to SERVICE.NAMESPACE.cluster.local
        k -n kube-system edit cm coredns
        kubernetes custom-domain cluster.local in-addr.arpa ip6.arpa {
Test your configuration for example from a Pod with busybox:1 image. These commands should result in an IP address:

nslookup kubernetes.default.svc.cluster.local
nslookup kubernetes.default.svc.custom-domain

# Question 17 | Find Container of Pod and check info | 6 of 6
In Namespace project-tiger create a Pod named tigers-reunite of image httpd:2-alpine with labels pod=container and container=pod. Find out on which node the Pod is scheduled. Ssh into that node and find the containerd container belonging to that Pod.

Using command crictl:

###    Write the ID of the container and the info.runtimeType into /opt/course/17/pod-container.txt
        crictl ps | grep tigers-reunite
        crictl inspect ba62e5d465ff0 | grep runtimeType

###    Write the logs of the container into /opt/course/17/pod-container.log
        crictl logs ba62e5d465ff0
