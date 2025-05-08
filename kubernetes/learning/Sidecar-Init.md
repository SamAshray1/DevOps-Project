## Init Containers

Specialized containers that run before app containers in a Pod. Init containers can contain utilities or setup scripts not present in an app image.
A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started.

Init containers are exactly like regular containers, except:

    Init containers always run to completion.
    Each init container must complete successfully before the next one starts.

## Sidecar Containers

Sidecar containers are the secondary containers that run along with the main application container within the same Pod. These containers are used to enhance or to extend the functionality of the primary app container by providing additional services, or functionality such as logging, monitoring, security, or data synchronization, without directly altering the primary application code.

Kubernetes implements sidecar containers as a special case of init containers; sidecar containers remain running after Pod startup.
If an init container is created with its restartPolicy set to Always, it will start and remain running during the entire life of the Pod.