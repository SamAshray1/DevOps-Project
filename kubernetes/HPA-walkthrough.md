# HPA Walkthrough

1. Enable the Metrics Server
2. Create HPA for the Deployment
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

3. Get the HPA
kubectl get hpa