## Node Affinity, Taints and Tolerations

Node affinity is a property of Pods that attracts them to a set of nodes (either as a preference or a hard requirement).
Taints are the opposite -- they allow a node to repel a set of pods.

Tolerations are applied to pods. Tolerations allow the scheduler to schedule pods with matching taints. Tolerations allow scheduling but don't guarantee scheduling: the scheduler also evaluates other parameters as part of its function.

Taints and tolerations work together to ensure that pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.


    Node affinity makes sure that pods are scheduled in particular nodes. 
    Taints are the opposite of node affinity; they allow a node to repel a set of pods. 
    Toleration is applied to pods and allows (but does not require) the pods to schedule onto nodes with matching taints.


# Taints/Tolerations + Node Affinity = Assures that a specific pod can only schedule on a specific node only and No other pods can be scheduled in tainted nodes.

# Taint-effect:

    NoSchedule: Pods will not be scheduled on the node unless they are tolerant. Pods won’t be scheduled, but if it is already running, it won’t kill it. No more new pods are scheduled on this node if it doesn’t match all the taints of this node.
    PreferNoSchedule: Scheduler will prefer not to schedule a pod on taint node but no guarantee. Means Scheduler will try not to place a Pod that does not tolerate the taint on the node, but it is not required.
    NoExecute: As soon as, NoExecute taint is applied to a node all the existing pods will be evicted without matching the toleration from the node.

# Affinity and anti-affinity
nodeSelector is the simplest way to constrain Pods to nodes with specific labels.
    requiredDuringSchedulingIgnoredDuringExecution: The scheduler can't schedule the Pod unless the rule is met. This functions like nodeSelector, but with a more expressive syntax.
    preferredDuringSchedulingIgnoredDuringExecution: The scheduler tries to find a node that meets the rule. If a matching node is not available, the scheduler still schedules the Pod.