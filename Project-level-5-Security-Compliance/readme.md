Jenkins Plugins

Pipeline: Stage View
GitHub Integration
Docker
docker pipeline
Github Credentials
AWS Credentials


Terraform -> Get Jenkins Instance

With Jenkins,
Build Image,
Scan Image
upload Image

Use secrets

Provision Resources

Deploy app into Cluster

### **Secure Secret Management in a React App Built into a Docker Image**  
We'll cover:  
✅ **Building the Docker Image**  
✅ **Scanning the Image (Trivy/Snyk)**  
✅ **Pushing to a Registry (ECR/DockerHub)**  
✅ **Managing Secrets Securely (Backend URL as a Secret in Vault)**  
✅ **Provisioning Resources**  
✅ **Deploying into Kubernetes**  

---

### **1. Secret Management in a React App**
#### **Problem: Avoid Hardcoding Backend URLs in React**
- React frontend often needs a backend API URL (e.g., `https://api.example.com`).
- This shouldn't be hardcoded in `Dockerfile` or `env` files within the image.

#### **Solution: Use HashiCorp Vault to Store Secrets**
- **Vault stores** `REACT_APP_BACKEND_URL`.
- **Jenkins fetches** the secret during the pipeline.
- **Docker build injects** the secret dynamically.

---

### **2. HashiCorp Vault Setup**
#### **Store Secret in Vault**
```bash
vault kv put secret/react-backend-url REACT_APP_BACKEND_URL="https://api.example.com"
```

#### **Fetch Secret Using Vault CLI (Jenkins or CI/CD)**
```bash
vault kv get -field=REACT_APP_BACKEND_URL secret/react-backend-url
```

---

### **3. Dockerfile (React App)**
```dockerfile
# Use Node.js for building React app
FROM node:18 AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY . .

# Build React app
ARG REACT_APP_BACKEND_URL
ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL
RUN npm run build

# Use Nginx for serving static files
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
```

🔹 **Note**: The `REACT_APP_BACKEND_URL` is passed as a build argument and injected dynamically.

---

### **4. Jenkins Pipeline (Build, Scan, Push, Deploy)**
```groovy
pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://vault:8200'  // Vault URL
    }

    stages {
        stage('Fetch Secret from Vault') {
            steps {
                script {
                    env.REACT_APP_BACKEND_URL = sh(
                        script: "vault kv get -field=REACT_APP_BACKEND_URL secret/react-backend-url",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build --build-arg REACT_APP_BACKEND_URL=${env.REACT_APP_BACKEND_URL} -t myapp:latest .
                    """
                }
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                sh "trivy image myapp:latest"
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh """
                        docker tag myapp:latest mydockerhubuser/myapp:latest
                        docker push mydockerhubuser/myapp:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }
}
```

---

### **5. Kubernetes Deployment (`k8s/deployment.yaml`)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
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
        image: mydockerhubuser/myapp:latest
        env:
        - name: REACT_APP_BACKEND_URL
          valueFrom:
            secretKeyRef:
              name: backend-url-secret
              key: REACT_APP_BACKEND_URL
---
apiVersion: v1
kind: Secret
metadata:
  name: backend-url-secret
type: Opaque
data:
  REACT_APP_BACKEND_URL: <base64-encoded-url>
```

---

### **6. Provision Resources (Terraform)**
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn
}

resource "aws_ecr_repository" "my_repo" {
  name = "my-react-app"
}
```

---

### **Flow Summary**
1️⃣ **Store Secret in Vault**  
2️⃣ **Jenkins fetches secret** → Passes `REACT_APP_BACKEND_URL` during Docker build  
3️⃣ **Docker builds image** → Uses the secret dynamically  
4️⃣ **Trivy scans image** for vulnerabilities  
5️⃣ **Pushes image to DockerHub/ECR**  
6️⃣ **Deploys to Kubernetes** (Secret is referenced securely in YAML)

---

### **Why This is Secure?**
✅ **No secrets in the repo**  
✅ **Dynamic secret injection**  
✅ **Vault manages secret lifecycle**  
✅ **Secure image scanning**  

---

Would you like a specific enhancement (e.g., AWS Secrets Manager instead of Vault)? 🚀