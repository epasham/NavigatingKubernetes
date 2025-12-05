####################
# jenkins service account
######################
---
apiVersion: v1
kind: Namespace
metadata:
  name: cicd
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-admin
  namespace: cicd
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins-admin
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: cicd
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: cicd
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/path:   /
      prometheus.io/port:   '8080'
spec:
  selector: 
    app: jenkins
  type: NodePort  
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 32000
---
####################
# jenkins ephemeral
######################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: cicd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      securityContext:
            fsGroup: 1000 
            runAsUser: 1000
      serviceAccountName: jenkins-admin
      containers:
        - name: jenkins
          image: jenkins/jenkins:2.528.2-lts
          resources:
            limits:
              memory: "1Gi"
              cpu: "1000m"
            requests:
              memory: "500Mi"
              cpu: "500m"
          ports:
            - name: httpport
              containerPort: 8080
            - name: jnlpport
              containerPort: 50000
          livenessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 90
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          volumeMounts:
            - name: jenkins-data
              mountPath: /var/jenkins_home         
      volumes:
        - name: jenkins-data
          emptyDir: {}
---
####################
# jenkins persistence
######################
# setup nfs storage on master
{
apt-get update -y
apt install nfs-kernel-server --fix-missing -y
systemctl enable nfs-server
systemctl start nfs-server
systemctl status nfs-server
mkdir -p /mnt/nfs/data
chmod -R 777 /mnt/nfs
chmod -R 777 /mnt/nfs/data
echo "/mnt/nfs/data *(rw,sync,no_subtree_check,insecure)" >> /etc/exports
exportfs -rav
exportfs -v
showmount -e
}

# install nfs client on worker node
ssh root@node01 apt install nfs-common -y

# mount nfs share on worker node
NFSIP=$(ip addr show enp1s0 | awk '$1 == "inet" { print $2 }' | cut -d/ -f1)
echo $NFSIP
ssh root@node01 mount -t nfs $NFSIP:/mnt/nfs/data /mnt
ssh root@node01 ls /mnt


# The jenkins-admin cluster role has all the permissions to manage the cluster components
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs-data
  namespace: cicd
  labels:
    type: nfs
    app: jenkins
spec:
  storageClassName: managed-nfs
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: <IP-ADDRESS>
    path: "/mnt/nfs/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs-data
  namespace: cicd
  labels:
    app: jenkins
spec:
  storageClassName: managed-nfs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: cicd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      serviceAccountName: jenkins-admin
      containers:
        - name: jenkins
          image: jenkins/jenkins:2.528.2-lts
          resources:
            limits:
              memory: "1Gi"
              cpu: "1000m"
            requests:
              memory: "500Mi"
              cpu: "500m"
          ports:
            - name: httpport
              containerPort: 8080
            - name: jnlpport
              containerPort: 50000
          livenessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 90
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          volumeMounts:
            - name: jenkins-data
              mountPath: /var/jenkins_home         
      volumes:
        - name: jenkins-data
          persistentVolumeClaim:
              claimName: pvc-nfs-data
---
