# Introduction 

This project attempts to simulate a multi-node 'production like' Kuberntes deployment for learning and development purposes. This project may be particularly useful if you work on K8 development or if you require a local K8 sandbox for learning purposes.

What this project does use [docker-compose](https://docs.docker.com/compose/) to deploy 3 node kubernetes deployment. Each node in reality is actually a ([docker-in-docker container](https://hub.docker.com/_/docker/) with ssh daemon running as specified in [node.dockerfile](./node.dockerfile). Each 'k8-container-node' has Docker 17.03 installed that will support Kubernetes v1.9. The [RKE](https://rancher.com/an-introduction-to-rke/) service within the docker-compose manifest will deploy kubernetes v1.9 across the `k8` docker bridge network to the 'k8-container-nodes' as defined in the [`cluster.yaml`](./k8-deploy-data/cluster.yaml) file. Once the K8 cluster has been deployed, you can then evoke a sandbox environment with [`kubectl`](https://kubernetes.io/docs/reference/kubectl/overview/) and [`helm`](https://github.com/kubernetes/helm) with relevant configurations ready to interact with the cluster.

# Pre-requisites 

To deploy a 3 node K8 cluster, you will require at minimum :

* 1 host with Docker 17.03 or above
* Minimum of 2 vCPU
* Minimum of 90 GB of free HDD space (hard requirement)
* Minimum of 4GB of RAM. 

I personally would recommend a light weight Container OS like [RancherOS](https://rancher.com/rancher-os/) as your desired docker host. You can refer to [`cloud-init.yaml`](./cloud-init.yaml) as an example to configure your basic Rancher OS install configurations. You can use the same ssh-key found [here](./k8-deploy-data/ssh-keys) to access the host if you desire.

# Instructions 

### **Step 1**

On your docker-host, clone this repository. 

```bash
git clone https://github.com/MayankTahil/k8-sandbox.git
cd k8-sandbox
```

### **Step 2** 

Next within this repository's directory, use `docker-compose` to provision your 3 target 'k8-container-nodes'. 

```bash
docker-compose up -d node-1
docker-compose up -d node-2
docker-compose up -d node-3
```

### **Step 3**

Next deploy your **RKE** service to deploy your K8 cluster. 

```bash
docker-compose up -d rke
```

Enter the following to follow along the deployment verbose output. 

```bash
docker-compose logs -f rke
```

>Deployment can take up to 15 min or more (depending on your Hard Drive's I/O speed). If everything is successful, you should read in the last two lines :
```
rke_1      | time="2018-01-15T05:49:05Z" level=info msg="Finished building Kubernetes cluster successfully"
k8sandbox_rke_1 exited with code 0` 
```

Also, if you encounter an issue with deploying addons, re-run the `docker-compose up -d RKE` command again after a few moments. Some services take a bit longer to resurrect. It is useful to note that RKE is an idempotent tool that can run several times, generating the same output.

## **Step 4**

Once your cluster is up and ready, you can then evoke a sandbox environment where you can interrogate your K8 cluster. Start your sandbox CLI by entering the following commands: 

```bash
docker-compose run sandbox bash
```

Next you can test out your kubectl binary by entering the following command: 

```bash
kubectl get nodes

>> 

NAME              STATUS    ROLES                AGE       VERSION
192.168.100.101   Ready     etcd,master,worker   21h       v1.9.0-rancher2
192.168.100.102   Ready     etcd,master,worker   21h       v1.9.0-rancher2
192.168.100.103   Ready     etcd,master,worker   21h       v1.9.0-rancher2
```

or even check all pods' status : 

```bash
NAMESPACE     NAME                                   READY     STATUS    RESTARTS   AGE
kube-system   kube-dns-579566db-dd4lz                3/3       Running   0          21h
kube-system   kube-dns-autoscaler-69fd77648c-6v8gw   1/1       Running   0          21h
kube-system   kube-flannel-gqtrj                     2/2       Running   0          21h
kube-system   kube-flannel-vgcpr                     2/2       Running   0          21h
kube-system   kube-flannel-vzfqr                     2/2       Running   0          21h
```

You can initiate [helm](https://github.com/kubernetes/helm) by entering the following command before deploying charts. 

```bash
helm init
```

# Additional Notes

You can change and update componenets of your K8 cluster by updating the [`cluster.yaml`](./k8-deploy-data/cluster.yaml) file and re-running the RKE service as defined in docker-compose (See **Step 3**). 

You can also scale your deployment by updating the [docker-compose.yaml](./docker-compose.yaml) file by adding additional nodes. 
