## install Kubernetes:

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

## autocomplete bash:

```
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

[Source: Kubernetes Docs](https://kubernetes.io/pt-br/docs/reference/kubectl/cheatsheet/)


## Get commands with basic output
### List all services in the namespace
```
kubectl get services
```                          
### List all pods in all namespaces
```
kubectl get pods --all-namespaces             
```
### List all pods in the current namespace, with more details
```
kubectl get pods -o wide                      
```
### List a particular deployment
```
kubectl get deployment my-dep                 
```
### List all pods in the namespace
```
kubectl get pods                              
```
### Get a pod's YAML
```
kubectl get pod my-pod -o yaml                
```
### Describe commands with verbose output
```
kubectl describe nodes my-node
```
```
kubectl describe pods my-pod
```

### List Services Sorted by Name
```
kubectl get services --sort-by=.metadata.name
```
### List pods Sorted by Restart Count
```
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'
```
### List PersistentVolumes sorted by capacity
```
kubectl get pv --sort-by=.spec.capacity.storage
```
### Get the version label of all pods with label app=cassandra
```
kubectl get pods --selector=app=cassandra -o \
  jsonpath='{.items[*].metadata.labels.version}'
```
### Retrieve the value of a key with dots, e.g. 'ca.crt'
```
kubectl get configmap myconfig \
  -o jsonpath='{.data.ca\.crt}'
```
### Retrieve a base64 encoded value with dashes instead of underscores.
```
kubectl get secret my-secret --template='{{index .data "key-name-with-dashes"}}'
```
### Get all worker nodes (use a selector to exclude results that have a label named 'node-role.kubernetes.io/control-plane')
```
kubectl get node --selector='!node-role.kubernetes.io/control-plane'
```
### Get all running pods in the namespace
```
kubectl get pods --field-selector=status.phase=Running
```
### Get ExternalIPs of all nodes
```
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'
```
### List Names of Pods that belong to Particular RC "jq" command useful for transformations that are too complex for jsonpath, it can be found at https://jqlang.github.io/jq/
```
sel=${$(kubectl get rc my-rc --output=json | jq -j '.spec.selector | to_entries | .[] | "\(.key)=\(.value),"')%?}
```
```
echo $(kubectl get pods --selector=$sel --output=jsonpath={.items..metadata.name})
```
### Show labels for all pods (or any other Kubernetes object that supports labelling)
```
kubectl get pods --show-labels
```
### Check which nodes are ready
```
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
 && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True"
```
### Check which nodes are ready with custom-columns
```
kubectl get node -o custom-columns='NODE_NAME:.metadata.name,STATUS:.status.conditions[?(@.type=="Ready")].status'
```
### Output decoded secrets without external tools
```
kubectl get secret my-secret -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'
```
### List all Secrets currently in use by a pod
```
kubectl get pods -o json | jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' | grep -v null | sort | uniq
```
### List all containerIDs of initContainer of all pods Helpful when cleaning up stopped containers, while avoiding removal of initContainers.
```
kubectl get pods --all-namespaces -o jsonpath='{range .items[*].status.initContainerStatuses[*]}{.containerID}{"\n"}{end}' | cut -d/ -f3
```
### List Events sorted by timestamp
```
kubectl get events --sort-by=.metadata.creationTimestamp
```
### List all warning events
```
kubectl events --types=Warning
```
### Compares the current state of the cluster against the state that the cluster would be in if the manifest was applied.
```
kubectl diff -f ./my-manifest.yaml
```
### Produce a period-delimited tree of all keys returned for nodes Helpful when locating a key within a complex nested JSON structure
```
kubectl get nodes -o json | jq -c 'paths|join(".")'
```
### Produce a period-delimited tree of all keys returned for pods, etc
```
kubectl get pods -o json | jq -c 'paths|join(".")'
```
### Produce ENV for all pods, assuming you have a default container for the pods, default namespace and the `env` command is supported. Helpful when running any supported command across all pods, not just `env`
```
for pod in $(kubectl get po --output=jsonpath={.items..metadata.name}); do echo $pod && kubectl exec -it $pod -- env; done
```
### Get a deployment's status subresource
```
kubectl get deployment nginx-deployment --subresource=status
```

[Source: k8s docs](https://kubernetes.io/docs/reference/kubectl/quick-reference/#viewing-and-finding-resources)


# Interacting with running Pods 
### dump pod logs (stdout)
```
kubectl logs my-pod                                 
```
### dump pod logs, with label name=myLabel (stdout)
```
kubectl logs -l name=myLabel                        
```
### dump pod logs (stdout) for a previous instantiation of a container
```
kubectl logs my-pod --previous                      
```
### dump pod container logs (stdout, multi-container case)
```
kubectl logs my-pod -c my-container                 
```
### dump pod container logs, with label name=myLabel (stdout)
```
kubectl logs -l name=myLabel -c my-container        
```
### dump pod container logs (stdout, multi-container case) for a previous instantiation of a container
```
kubectl logs my-pod -c my-container --previous      
```
### stream pod logs (stdout)
```
kubectl logs -f my-pod                              
```
### stream pod container logs (stdout, multi-container case)
```
kubectl logs -f my-pod -c my-container              
```
### stream all pods logs with label name=myLabel (stdout)
```
kubectl logs -f -l name=myLabel --all-containers    
```
### Run pod as interactive shell
```
kubectl run -i --tty busybox --image=busybox:1.28 -- sh  
```
### Start a single instance of nginx pod in the namespace of mynamespace
```
kubectl run nginx --image=nginx -n mynamespace      
```
### Generate spec for running pod nginx and write it into a file called pod.yaml
```
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
```
### Attach to Running Container
```                                                    
kubectl attach my-pod -i                            
```
### Listen on port 5000 on the local machine and forward to port 6000 on my-pod
```
kubectl port-forward my-pod 5000:6000               
```
### Run command in existing pod (1 container case)
```
kubectl exec my-pod -- ls /                         
```
### Interactive shell access to a running pod (1 container case)
```
kubectl exec --stdin --tty my-pod -- /bin/sh        
```
### Run command in existing pod (multi-container case)
```
kubectl exec my-pod -c my-container -- ls /         
```
### Create an interactive debugging session within existing pod and immediately attach to it
```
kubectl debug my-pod -it --image=busybox:1.28       
```
### Create an interactive debugging session on a node and immediately attach to it
```
kubectl debug node/my-node -it --image=busybox:1.28 
```
### Show metrics for all pods in the default namespace
```
kubectl top pod                                     
```
### Show metrics for a given pod and its containers
```
kubectl top pod POD_NAME --containers               
```
### Show metrics for a given pod and sort it by 'cpu' or 'memory'
```
kubectl top pod POD_NAME --sort-by=cpu              
```

[Source: k8s docs](https://kubernetes.io/docs/reference/kubectl/quick-reference/#interacting-with-running-pods)

## Copying files and directories to and from containers
### Copy /tmp/foo_dir local directory to /tmp/bar_dir in a remote pod in the current namespace
```
kubectl cp /tmp/foo_dir my-pod:/tmp/bar_dir            
```
### Copy /tmp/foo local file to /tmp/bar in a remote pod in a specific container
```
kubectl cp /tmp/foo my-pod:/tmp/bar -c my-container 
```
### Copy /tmp/foo local file to /tmp/bar in a remote pod in namespace my-namespace
```
kubectl cp /tmp/foo my-namespace/my-pod:/tmp/bar       
```
### Copy /tmp/foo from a remote pod to /tmp/bar locally
```
kubectl cp my-namespace/my-pod:/tmp/foo /tmp/bar      
```
[Source: k8s docs](https://kubernetes.io/docs/reference/kubectl/quick-reference/#copying-files-and-directories-to-and-from-containers)

## Interacting with Deployments and Services
### dump Pod logs for a Deployment (single-container case)
```
kubectl logs deploy/my-deployment
```
### dump Pod logs for a Deployment (multi-container case)
```
kubectl logs deploy/my-deployment -c my-container
```
### listen on local port 5000 and forward to port 5000 on Service backend        
```
kubectl port-forward svc/my-service 5000
```
### listen on local port 5000 and forward to Service target port with name <my-service-port>
```                
kubectl port-forward svc/my-service 5000:my-service-port  
```
### listen on local port 5000 and forward to port 6000 on a Pod created by <my-deployment>
```
kubectl port-forward deploy/my-deployment 5000:6000
```
### run command in first Pod and first container in Deployment (single- or multi-container cases)
```      
kubectl exec deploy/my-deployment -- ls
```
[Source: k8s docs](https://kubernetes.io/docs/reference/kubectl/quick-reference/#interacting-with-deployments-and-services)       

## Interacting with Nodes and cluster
### Mark my-node as unschedulable
```
kubectl cordon my-node
```
### Drain my-node in preparation for maintenance
```
kubectl drain my-node
```
### Mark my-node as schedulable
```
kubectl uncordon my-node
```
### Show metrics for all nodes
```
kubectl top node
```
### Show metrics for a given node
```                                                      
kubectl top node my-node
```
### Display addresses of the master and services
```
kubectl cluster-info
```
### Dump current cluster state to stdout
```
kubectl cluster-info dump
```
### Dump current cluster state to /path/to/cluster-state
```
kubectl cluster-info dump --output-directory=/path/to/cluster-state
```
[Source: k8s docs](https://kubernetes.io/docs/reference/kubectl/quick-reference/#interacting-with-nodes-and-cluster)
