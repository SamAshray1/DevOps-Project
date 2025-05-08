## ConfigMaps and Secrets Day 9

# ConfigMaps
A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

Secrets are similar to ConfigMaps but are specifically intended to hold confidential data.

# Secrets
A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image. Using a Secret means that you don't need to include confidential data in your application code.

Because Secrets can be created independently of the Pods that use them, there is less risk of the Secret (and its data) being exposed during the workflow of creating, viewing, and editing Pods. Kubernetes, and applications that run in your cluster, can also take additional precautions with Secrets, such as avoiding writing sensitive data to nonvolatile storage.

In order to safely use Secrets, take at least the following steps:

    Enable Encryption at Rest for Secrets.
    Enable or configure RBAC rules with least-privilege access to Secrets.
    Restrict Secret access to specific containers.
    Consider using external Secret store providers.