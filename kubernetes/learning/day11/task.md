## Task details
Switch back to the original context with admin permissions.
    k config use-context kubernetes-admin@kubernetes

Create a new Role named pod-reader. The Role should grant permissions to get, watch and list Pods.
role.yml

Create a new RoleBinding named read-pods. Map the user krishna to the Role named pod-reader.
    
Make sure that both objects have been created properly.
Switch to the context named sam.
Create a new Pod named nginx with the image nginx. What would you expect to happen?
    Pod won't be created as sam user has no permissions to create resources.

List the Pods in the namespace. What would you expect to happen?
    We can see the pods in the namespaces.

Create a new deploymened named nginx-deploy. What would you expect to happen?
    Deployment won't be created as sam user has no permissions to create resources.

# to check who you are
kubectl auth whoami

# to check if you have access to a particular resource
k auth can-i create po
k auth can-i create po --as krishna
