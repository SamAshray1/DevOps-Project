### **Jenkins Pipeline for Deploying React App to EKS using Helm**  

This pipeline will:  
✅ **Build a Docker image** for the React app  
✅ **Push the image** to DockerHub / AWS ECR  
✅ **Provision an EKS cluster** using Terraform  
✅ **Deploy the React app** using Helm  

---

## **1️⃣ Jenkins Requirements**  
### **🔹 Jenkins Plugins Required**
- **Pipeline** (`Pipeline` plugin) → For declarative pipeline  
- **Docker Pipeline** (`docker-workflow`) → To build/push Docker images  
- **AWS CLI** (`aws-cli`) → To interact with AWS  
- **Kubernetes CLI** (`kubernetes-cli`) → To manage EKS  
- **Terraform** (`terraform`) → To provision EKS  
- **Helm** (`helm`) → To deploy the React app  
GitHub Integration
Pipeline: GitHub

Install via **Jenkins UI**:  
`Manage Jenkins` → `Manage Plugins` → `Available Plugins`  

---

## **2️⃣ Jenkinsfile Stages Breakdown**
```groovy
pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        EKS_CLUSTER_NAME = "my-eks-cluster"
        DOCKER_REPO = "your-dockerhub-username/react-app"
        ECR_REPO = "123456789012.dkr.ecr.us-east-1.amazonaws.com/react-app"
    }

    stages {
        
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-org/react-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_REPO}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    script {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        docker tag ${DOCKER_REPO}:${BUILD_NUMBER} $ECR_REPO:${BUILD_NUMBER}
                        docker push $ECR_REPO:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Provision EKS Cluster with Terraform') {
            steps {
                script {
                    sh """
                        cd terraform/
                        terraform init
                        terraform apply -auto-approve
                    """
                }
            }
        }

        stage('Configure kubectl for EKS') {
            steps {
                script {
                    sh """
                        aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME
                        kubectl get nodes
                    """
                }
            }
        }

        stage('Deploy App using Helm') {
            steps {
                script {
                    sh """
                        helm repo add my-chart-repo https://your-helm-repo
                        helm upgrade --install react-app ./helm-chart --set image.repository=$ECR_REPO,image.tag=${BUILD_NUMBER}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
```

---

## **3️⃣ Breakdown of Each Stage**  

| **Stage** | **Purpose** |
|-----------|------------|
| `Checkout Code` | Clones the React app repo from GitHub |
| `Build Docker Image` | Builds a Docker image of the React app |
| `Push to DockerHub` | Pushes the image to DockerHub |
| `Push to AWS ECR` | Pushes the image to AWS Elastic Container Registry (ECR) |
| `Provision EKS Cluster with Terraform` | Uses Terraform to create an EKS cluster |
| `Configure kubectl for EKS` | Updates `kubectl` to connect with EKS |
| `Deploy App using Helm` | Deploys the app using Helm |

---

## **4️⃣ Infrastructure Setup (Terraform)**
📂 **Directory Structure**
```
├── Jenkinsfile
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── helm-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── templates/
```

### **🔹 Terraform (`main.tf`)**
```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "eks" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }
}
```
✅ This creates an EKS cluster.

---

## **5️⃣ Deployment with Helm**
### **🔹 Helm Values (`values.yaml`)**
```yaml
image:
  repository: 123456789012.dkr.ecr.us-east-1.amazonaws.com/react-app
  tag: latest
```
✅ Helm will deploy the latest React app.

---

## **6️⃣ Credentials Setup in Jenkins**
### **🔹 Required Credentials**
1. **DockerHub Credentials** → Add as `docker-hub-credentials`
2. **AWS Credentials** → IAM user with EKS, ECR permissions
3. **Terraform State Backend** (optional) → If using S3 for remote state

---

## **✅ Summary**
- **Jenkins Pipeline** automates **Docker build, EKS provisioning, and Helm deployment**.
- **Terraform** provisions an **EKS cluster**.
- **Helm** deploys the **React app**.
- Uses **DockerHub or AWS ECR** for images.

Now, every Jenkins run will **build, push, provision, and deploy** 🚀!