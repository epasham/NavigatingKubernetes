# expose the dashboard UI
POD_NAME=$(k -n kubernetes-dashboard get pods -l "k8s-app=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")
k -n kubernetes-dashboard port-forward --address 0.0.0.0 $POD_NAME 9000:9090 &

# add ClusterRoleBinding to view cluster level resources

cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-admin
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
  #name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
EOF
