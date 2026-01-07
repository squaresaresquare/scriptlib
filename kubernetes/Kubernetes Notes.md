Kubernetes Notes

kubectl command line tool for the kubeapi



###### kubernetes services

  	ClusterIP (default): Allows for internal communication of Pods. Only accessible from within the cluster.
  	NodePort: This exposes the Service on a static port of each Node, making It accessible from outside the cluster.
  	LoadBalancer: Uses a cloud provider’s external load balancer. The Service is then accessible via a public IP.
  	ExternalName: Maps a Kubernetes Service to an external hostname.

 

###### Kubernetes network concepts

  	Pod-to-pod communication: Each Pod gets a unique IP assigned and can communicate within the cluster.
  	Service-to-pod communication: Services provide a stable network endpoint for a group of Pods, as Pods are ephemeral. Each pod gets a new IP assigned every time it is created.
  	Ingress controllers: Manage external HTTP/HTTPS traffic.
  	Network policies: Define rules to restrict or allow communication between Pods.

##### 

###### RBAC

 Roles and ClusterRoles: Define the actions allowed on resources.
 RoleBindings and ClusterRoleBindings: Assign roles to users or service accounts.



Autoscaling

Horizontal Pod Autoscaler (HPA): Adjusts the number of Pods based on CPU usage, memory usage, or custom metrics.

Vertical Pod Autoscaler (VPA): Adjusts the CPU and memory requests for individual Pods.

Cluster Autoscaler: Adjusts the number of worker nodes in the cluster based on resource needs.



###### Taints

In Kubernetes, taints are a mechanism to mark a node, indicating that the node should repel a set of pods. This means that a pod will not be scheduled on a tainted node unless it has a matching toleration. Taints are used to control which pods can run on specific nodes, providing granular control over workload placement.





###### Manual cluster setup 

(normally in ansible + puppet)



1. Prepare the Infrastructure: Provision virtual machines or bare-metal servers for your master and worker nodes, ensuring they meet the minimum resource requirements.
2. Install Container Runtime: Install a container runtime (e.g., containerd, Docker) on all nodes.
3. Install Kubernetes Components: Install kubeadm, kubelet, and kubectl on all nodes.
4. Disable Swap: Disable swap on all nodes as it can interfere with Kubernetes' memory management.
5. Initialize the Control Plane: On the designated master node, initialize the Kubernetes control plane using kubeadm init. This command sets up the necessary control plane components like kube-apiserver, etcd, kube-scheduler, and kube-controller-manager.
6. Set Up Cluster Networking: Install your chosen CNI plugin to enable pod-to-pod communication across the cluster.
7. Join Worker Nodes: On each worker node, use the kubeadm join command (provided during the kubeadm init output) to connect them to the control plane.
8. Verify Cluster Setup: Use kubectl get nodes and kubectl get pods --all-namespaces to confirm that all nodes are ready and system pods are running.
9. Install Add-ons: Deploy optional components like the Kubernetes Dashboard, Metrics Server, and any necessary storage or ingress controllers.



##### kube-proxy

 Service-to-Pod Mapping:

&nbsp;	kube-proxy keeps track of the IP addresses of Pods associated with a particular Service and ensures that traffic directed to the Service's IP address is correctly routed to the appropriate Pods.



 Load Balancing:

&nbsp;	It distributes incoming traffic across the multiple Pods backing a Service, providing load balancing and ensuring high availability of applications.



 Network Rule Management:

&nbsp;	kube-proxy maintains network rules on the node, such as iptables or IPVS rules (depending on the configured proxy mode), to facilitate the routing and load balancing of Service traffic.



 Dynamic Updates:

&nbsp;	As Pods are created, terminated, or change their state, kube-proxy dynamically updates the network rules to reflect these changes, ensuring that Service-to-Pod mapping remains accurate and up-to-date.



kube-state-metrics



Prometheus



###### Kubernetes and TLS and PKI

If you're using kubeadm then you only need the root CA's certs and keys

otherwise you need:

etcd certs

client certs

api  certs



certs should be stored in a vault external to Kubernetes for recovery and provisioning new nodes





Manage the overall state of the cluster:



##### Kubernetes components

kube-apiserver

The core component server that exposes the Kubernetes HTTP API.



etcd

Consistent and highly-available key value store for all API server data.



kube-scheduler

Looks for Pods not yet bound to a node, and assigns each Pod to a suitable node.



kube-controller-manager

Runs controllers to implement Kubernetes API behavior.



###### Kubernetes mutating admission webhook

used to inject settings into pods, resource limits, sidecars etc



###### Add ons:

image registry server for (docker/containerd)

metadata db: etcd (or kine+postgres),



###### Cluster tools

load balancing or service-mesh: istio

network cni: flannel or calico (maybe canal for flannel + policy enforcement for compliance)



###### administrative tools

helm, legend, jsonnet?

server and cluster configuration enforcement puppet. 

automation ci/cd: ansible, Jenkins, git 

secret/password management, hashicorp vault, etc.

security scanning: kubebench or kubesec, 

metrics, logging, monitoring, alerting, observability, capacity forcasting 



general Linux environment bootstrapping:

pxe, kickstart, cobbler, puppet, yum repo, 





###### Safely upgrade a bare metal cluster

 Drain and backup etcd, before the upgrade to ensure that you can restore it in case the upgrade fails.
 Upgrade the control plane node.
 Upgrade kubelet and kubectl on control plane nodes.
 Upgrade worker nodes one by one. Before upgrading, each worker node must be drained to prevent workload disruption.
 Upgrade cluster add-ons (e.g., Ingress controllers, monitoring tools, …).



###### considerations

minimize the number of helper apps to lower the number of technologies the client needs to know to operate it.


security/compliance/regulatory.

built in security, but keep it as native as possible. plugins vs stand-alone apps.

build for current compliance requirements

or

build for future requirements or new regulations.



what if more hardware capacity is needed



Network segmentation for security (cni)
pod subnet
service subnet
master (control plane) subnet
