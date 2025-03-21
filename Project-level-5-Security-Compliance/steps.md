Jenkins Plugins

Pipeline: Stage View
GitHub Integration
Docker
docker pipeline
Github Credentials
AWS Credentials
HashiCorp Vault Plugin
Hashicorp Vault Pipeline Plugin
AWS Steps

Add Github Credentials
Add Docker Credentials

Install docker on jenkins instance
Install Vault
Install AWS
JQ
kubectl

give jenkins access to docker
sudo usermod -aG docker jenkins

restart
sudo systemctl restart jenkins
sudo systemctl restart docker

Copy the root token and add it to Jenkins:

    Go to Manage Jenkins → Manage Credentials.
    Add a Secret Text credential with Vault Token.

Install Vault Plugin:

    Manage Jenkins → Plugin Manager → Install "HashiCorp Vault Plugin".

Configure Vault in Jenkins:

    Manage Jenkins → Configure System.
    Under Vault Configuration, set:
        Vault URL: http://<VAULT_EC2_IP>:8200
        Credentials: Select Vault Token (or AppRole if configured).


install terraform

Create EKS cluster manually

ClusterRole and NodeRole

K8s-user

Trust:
"Principal": {
"AWS": "arn:aws:iam:k8s-user",

Policy:
IAMFullAccess

Custom:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:DescribeCluster",
            "Resource": "*"
        }
    ]
}

aws sts assume-role --role-arn arn:aws:iam::AmazonEKSAutoClusterRole --role-session-name eks-connection

export AWS_ACCESS_KEY_ID=<your-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export AWS_SESSION_TOKEN=<your-session-token>

aws sts get-caller-identity