#############
# minio docker compose
#############
docker-compose -f minio-docker-compose.yaml up &

# to uninstall
docker-compose -f minio-docker-compose.yaml down

#############
# minio kubernetes
#############
# UI
kubectl port-forward svc/minio --address 0.0.0.0  9001:9001 &

# Launch minio console on port 9001 in browser and create a bucket say, ek-bucket

# Verify that the bucket is replicated in all the 3 pods
controlplane:~$ k exec -it minio-0 -- sh
sh-5.1# cd /data
sh-5.1# ls -l
total 4
drwxr-xr-x 2 root root 4096 Dec  5 15:02 ek-bucket
sh-5.1# 
sh-5.1# exit

controlplane:~$ k exec -it minio-1 -- sh
sh-5.1# ls -l /data
total 4
drwxr-xr-x 2 root root 4096 Dec  5 15:02 ek-bucket
sh-5.1# exit

controlplane:~$ 
controlplane:~$ k exec -it minio-2 -- sh
sh-5.1# ls -l /data
total 4
drwxr-xr-x 2 root root 4096 Dec  5 15:02 ek-bucket
sh-5.1# 

#############
# minio client
#############
kubectl apply -f minio-client-job.yaml

k exec -it minio-0 -- /bin/sh -c "ls /data"
mimir-metrics  tempo-traces

k exec -it minio-1 -- /bin/sh -c "ls /data"
mimir-metrics  tempo-traces

k exec -it minio-2 -- /bin/sh -c "ls /data"
mimir-metrics  tempo-traces
