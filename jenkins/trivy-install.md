## Installing Trivy on Ubuntu

sudo apt-get install wget apt-transport-https gnupg lsb-release

# Add the Trivy GPG key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy-archive-keyring.gpg

# Add the Trivy repository
echo "deb [signed-by=/usr/share/keyrings/trivy-archive-keyring.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

# Update package lists
sudo apt update

# Install Trivy
sudo apt install -y trivy


trivy server --listen 0.0.0.0:4954