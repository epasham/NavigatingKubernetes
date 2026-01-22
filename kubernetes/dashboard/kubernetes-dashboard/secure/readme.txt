helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/ && helm repo update

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace --namespace kubernetes-dashboard --set kong.proxy.http.enabled=true

kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8080:80 &

# Uninstall
helm -n kubernetes-dashboard uninstall kubernetes-dashboard
