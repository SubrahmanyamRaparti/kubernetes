# Add a taint to a node
# kubectl taint node node-name KEY_1=VAL_1:TAINT_EFFECT_1 ... KEY_N=VAL_N:TAINT_EFFECT_N
# The effect must be NoSchedule, PreferNoSchedule or NoExecute.
kubectl taint node node01 app=proxy:NoSchedule

# Refer to SampleObjects/deployment.yaml for toleration example

# Remove a taint from a node
kubectl taint node node01 app-

# Taints & tolerations can either deny or allow pods to get placed on a node. But, it will not tell on which node does the pod need to be placed.

#-----------------------#
# Example of NoSchedule #
#-----------------------#
# With taint effect as NoSchedule means that no pod will be able to schedule onto node1 unless it has a matching toleration.
# Pods those are already present on node before the tainting the node will remain even though they are not tolerant.

# subrahmanyam:~/environment $ kubectl taint node node01 app=pla:NoSchedule
# node/node01 tainted

# subrahmanyam:~/environment $ kubectl get all -o wide
# NAME                         READY   STATUS    RESTARTS   AGE     IP            NODE     NOMINATED NODE   READINESS GATES
# pod/proxy-76756f7d6c-87sfl   1/1     Running   0          4m12s   10.244.1.25   node01   <none>           <none>
# pod/proxy-76756f7d6c-ff4rh   1/1     Running   0          4m12s   10.244.1.26   node01   <none>           <none>
# pod/proxy-76756f7d6c-thnn2   1/1     Running   0          4m12s   10.244.1.27   node01   <none>           <none>

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d2h   <none>

# NAME                    READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES   SELECTOR
# deployment.apps/proxy   3/3     3            3           4m12s   nginx        nginx    app=proxy

# NAME                               DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES   SELECTOR
# replicaset.apps/proxy-76756f7d6c   3         3         3       4m12s   nginx        nginx    app=proxy,pod-template-hash=76756f7d6c

# subrahmanyam:~/environment $ kubectl apply -f SampleObjects/pod.yaml 
# pod/proxy created

# subrahmanyam:~/environment $ kubectl get all -o wide
# NAME                         READY   STATUS    RESTARTS   AGE     IP            NODE     NOMINATED NODE   READINESS GATES
# pod/proxy                    0/1     Pending   0          6s      <none>        <none>   <none>           <none>
# pod/proxy-76756f7d6c-87sfl   1/1     Running   0          4m29s   10.244.1.25   node01   <none>           <none>
# pod/proxy-76756f7d6c-ff4rh   1/1     Running   0          4m29s   10.244.1.26   node01   <none>           <none>
# pod/proxy-76756f7d6c-thnn2   1/1     Running   0          4m29s   10.244.1.27   node01   <none>           <none>

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d2h   <none>

# NAME                    READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES   SELECTOR
# deployment.apps/proxy   3/3     3            3           4m29s   nginx        nginx    app=proxy

# NAME                               DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES   SELECTOR
# replicaset.apps/proxy-76756f7d6c   3         3         3       4m29s   nginx        nginx    app=proxy,pod-template-hash=76756f7d6c

#-----------------------------#
# Example of PreferNoSchedule #
#-----------------------------#
# This is a "preference" or "soft" version of NoSchedule, system will try to avoid placing a pod that does not tolerate the taint on the node, 
# but it is not required/mandatory. 

# subrahmanyam:~/environment $ kubectl taint node node01 app=pla:PreferNoSchedule
# node/node01 tainted

# subrahmanyam:~/environment $ kubectl apply -f SampleObjects/deployment.yaml                                                                                              
# deployment.apps/proxy created

# subrahmanyam:~/environment $ kubectl get all -o wide
# NAME                         READY   STATUS    RESTARTS   AGE   IP            NODE     NOMINATED NODE   READINESS GATES
# pod/proxy-76756f7d6c-87sfl   1/1     Running   0          9s    10.244.1.25   node01   <none>           <none>
# pod/proxy-76756f7d6c-ff4rh   1/1     Running   0          9s    10.244.1.26   node01   <none>           <none>
# pod/proxy-76756f7d6c-thnn2   1/1     Running   0          9s    10.244.1.27   node01   <none>           <none>

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d2h   <none>

# NAME                    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES   SELECTOR
# deployment.apps/proxy   3/3     3            3           9s    nginx        nginx    app=proxy

# NAME                               DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES   SELECTOR
# replicaset.apps/proxy-76756f7d6c   3         3         3       9s    nginx        nginx    app=proxy,pod-template-hash=76756f7d6c

#----------------------#
# Example of NoExecute #
#----------------------#
# Normally, if a taint with effect NoExecute is added to a node, then any pods that do not tolerate the taint will be evicted immediately, 
# and pods that do tolerate the taint will never be evicted.

# subrahmanyam:~/environment $ kubectl get all -o wide
# NAME        READY   STATUS    RESTARTS   AGE    IP            NODE     NOMINATED NODE   READINESS GATES
# pod/proxy   1/1     Running   0          118s   10.244.1.24   node01   <none>           <none>

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d1h   <none>

# subrahmanyam:~/environment $ kubectl taint node node01 app=pla:NoExecute
# node/node01 tainted

# subrahmanyam:~/environment $ kubectl get all -o wide
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d1h   <none>