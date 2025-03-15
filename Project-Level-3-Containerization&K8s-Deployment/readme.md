# Deploying a React App to AWS EKS with Jenkins

This guide covers deploying a React application to AWS EKS using Jenkins. The process includes building a Docker image, pushing it to DockerHub, configuring AWS credentials, updating kubeconfig, and applying a Kubernetes deployment.

## Prerequisites

- **Jenkins** installed and configured
- **AWS CLI** installed
- **Kubectl** installed
- **Docker** installed and configured
- **An AWS EKS Cluster** set up
- **IAM Role** with necessary permissions for deployment

## Steps

### 1️⃣ Git Checkout
Clone the repository containing the React app:
```sh
 git clone https://github.com/SamAshray1/portfolio-website.git
 cd portfolio-website
```

### 2️⃣ Build Docker Image
Build the Docker image for the React application:
```sh
docker build -t samqwerty12/react-app .
```

### 3️⃣ Push to DockerHub
Log in and push the image to DockerHub:
```sh
docker login -u samqwerty12 -p <your-dockerhub-password>
docker push samqwerty12/react-app
```

### 4️⃣ Assume AWS IAM Role
Assume the necessary IAM role for EKS deployment:
```sh
aws sts assume-role --role-arn <arn:aws:iam::CLUSTER-ROLE> --role-session-name jenkins-eks-session --output json
```

### 5️⃣ Update Kubeconfig
Update the Kubernetes config to connect to the EKS cluster:
```sh
aws eks update-kubeconfig --region us-east-1 --name <EKS_CLUSTER_NAME>
```

### 6️⃣ Deploy to EKS
Apply the deployment file to deploy the React app:
```sh
kubectl apply -f deployment.yml
kubectl get pods
```

## Kubernetes Deployment YAML
Create a `deployment.yml` file:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
  labels:
    app: react-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
      - name: react-app
        image: samqwerty12/react-app:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: react-app-service
spec:
  type: LoadBalancer
  selector:
    app: react-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

### 🎉 Application Deployed!
Once the deployment is complete, get the external LoadBalancer URL:
```sh
kubectl get svc react-app-service
```
Visit the URL to access your React app. 🚀

## Troublshooting Tips

### Docker Run Error
Give jenkins user access to docker
```sh
sudo usermod -aG docker jenkins
```

Restart Docker and Jenkins
```sh
sudo systemctl restart jenkins
sudo systemctl restart docker
```

### IAM Role Errors
Make sure the Cluster IAM role (created along with EKS Cluster), has trusted the jenkins-user IAM User.
Then only can the jenkins-user credentials can assume the Cluster-Role

In AWS Management Console,
Go to IAM
Roles >> <CLUSTER-ROLE> >> Trust Relationships
Add Below under "Principal"

"Principal": {
"AWS": "<arn:aws:JENKINS-USER>"
}



Make sure in Clusters >> <YOUR_CLUSTER> >> Access tab >> IAM Access Entries,
That the <CLUSTER-ROLE> has EKSClusterAdmin Policy. (Currently using this to Create Resources, can apply other policies for better security / limited access to jenkin-user)



