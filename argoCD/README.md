# ArgoCD

## What is GitOps?
GitOps uses Git as a single source of truth to deliver applications and infrastructure.

## Advantages of GitOps
- Security
- Versioning
- Auto Upgrades
- Auto Healing of Unwanted changes
- Continuous Reconciliation

## Principles of GitOps
The desired state of a GitOps managed system must be:

    Declarative
    A system managed by GitOps must have its desired state expressed declaratively.

    Versioned and Immutable
    Desired state is stored in a way that enforces immutability, versioning and retains a complete version history.

    Pulled Automatically
    Software agents automatically pull the desired state declarations from the source.

    Continuously Reconciled
    Software agents continuously observe actual system state and attempt to apply the desired state.
