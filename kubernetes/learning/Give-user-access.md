# Giving New Users access to K8s cluster

## On your Local Machine
openssl genrsa -out sam.key 2048

openssl req -new -key sam.key -subj "/CN=sam" -out sam.csr

openssl x509 -req -in sam-user.csr -CA /etc/kubernetes/pki/ca.crt  -CAkey /etc/kubernetes/pki/ca.key  -CAcreateserial -out sam.crt -days 365
## Send .csr file to K8s admin

## In K8s Cluster / By K8s admin

cat sam.csr | base64 -w 0

### Take output of above and put into REQUEST of below

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: sam
spec:
  groups:
  - system:authenticated
  request: REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

k certificate approve sam

k get csr sam -o jsonpath='{.status.certificate}' | base64 -d > sam.crt

## Send .crt and /etc/manifests/pki/ca.crt to New User

## In Local Machine

kubectl config set-cluster my-cluster  --server=https://<EC2-PUBLIC-IP>:6443   --certificate-authority=ca.crt

k config set-credentials sam --client-key=sam.key --client-certificate=sam.crt --embed-certs

k config set-context sam --user=sam --cluster=my-cluster

k config use-context sam