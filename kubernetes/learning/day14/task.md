### Task details
1. Create a PersistentVolume named `pv-demo`, access mode `ReadWriteMany`, 512Mi of storage capacity and the host path `/data/config`.
2. Create a PersistentVolumeClaim named `pvc-demo`. The claim should request 256Mi and use an empty string value for the storage class. Please make sure that the PersistentVolumeClaim is properly bound after its creation.
3. Mount the PersistentVolumeClaim from a new Pod named `app` with the path `/var/app/config`. The Pod uses the image `nginx:latest`.
4. Open an interactive shell to the Pod and create a file in the directory `/var/app/config`.
