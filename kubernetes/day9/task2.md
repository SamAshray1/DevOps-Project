## Task details

Perform the task given here : https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data

Define an environment variable as a key-value pair in a Secret:
kubectl create secret generic backend-user --from-literal=backend-username='backend-admin'