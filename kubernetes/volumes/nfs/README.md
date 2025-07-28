# Install nfs-server ( run it on kubernetes node or a dedicated nfs server )
wget https://raw.githubusercontent.com/epasham/NavigatingKubernetes/main/kubernetes/volumes/nfs/1.install-nfs-server.sh
chmod +x ./1.install-nfs-server.sh

scp ./1.install-nfs-server.sh kube-node01:~/

# Install nfs client and mount nfs share ( run it on kubernetes master node )
wget https://raw.githubusercontent.com/epasham/NavigatingKubernetes/main/kubernetes/volumes/nfs/2.mount-nfs-share.sh
chmod +x ./2.mount-nfs-share.sh

