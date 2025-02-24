### Task details
1. Login to your cluster on worker node1 and clone this repo.
2. cd into the cloned directory inside `CKA-2024/Resources/Day39` folder
3. Execute the below .sh file which introduces issues in your cluster (Do not open the file)
`chmod 777 problem1.sh;./problem1.sh`
4. Check your cluster health again and fix the nodes.
5. Once, your nodes are in ready status, clone the repo on worker node2
6. Execute the below .sh file which introduces issues in your cluster (Do not open the file)
`chmod 777 problem2.sh;./problem2.sh`
7. Check your cluster health again and fix the nodes.
  
## Solution
Problem 1

systemctl status kubelet
journal -u kubelet

Found /var/lib/kubelet/config.yml is looking for .crt file in /etc/kubernetes/pki, but wrong .crt filename is present.
Changed the certname in config.yml and restarted kubelet on worker

systemctl restart kubelet


Problem 2
kubelet was down on worker, restarted kubelet

systemctl restart kubelet