# How to debug container that doesn't include debugging utilities
Solution: You can use the kubectl debug command to add ephemeral containers to a running Pod

# Let us create pause container. it does not contain debugging utilities
kubectl run debug-demo --image=registry.k8s.io/pause:3.1 --restart=Never

kubectl exec -it debug-demo -- sh
error: Internal error occurred: Internal error occurred: error executing command in container: 
failed to exec in container: failed to start exec "fb07c5f6c86df41de8b0156667f08aa18792a7a72dfd55c968b98ec5fab2ff27": 
OCI runtime exec failed: exec failed: unable to start container process: exec: "sh": executable file not found in $PATH: unknown

# Note
If you attempt to use kubectl exec to create a shell you will see an error because there is no shell in this container image.

# add a debugging container using kubectl debug. 
kubectl -n <namespace> debug -it <pod-name> --image=busybox --target=<container-name>

# If you specify the -i/--interactive argument, kubectl will automatically attach to the console of the Ephemeral Container.
kubectl debug -it debug-demo  --image=ekambaram/debug-tool:latest --target=debug-demo
Defaulting debug container name to debugger-8xzrl.
If you don't see a command prompt, try pressing enter.
/ #


The above command adds a debug-tool container and attaches to debug-demo pod. 

Note:
The --target parameter must be supported by the Container Runtime
