helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/ && helm repo update

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace --namespace kubernetes-dashboard --set kong.proxy.http.enabled=true

kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8080:80 &

############
# Create user
############
k apply -f create-admin-user.yaml

# Create token that is used to log in
k -n kubernetes-dashboard create token admin-user

It should print something like:
eyJhbGciOiJSUzI1NiIsImtpZCI6ImxWVkdHNVkzWHgzeU8xZDdldmpWZXBVQmJLaXBvLUFuR2U2TlZ6MXZRY3cifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGV


####################
# Getting a long-lived Bearer Token for ServiceAccount and the token will be saved in the Secret
####################
# create a token with the secret which bound the service account
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "admin-user"   
type: kubernetes.io/service-account-token
EOF

# After Secret is created, get the token which is saved in the Secret:
k -n kubernetes-dashboard get secret admin-user -o jsonpath="{.data.token}" | base64 -d

# Access Dashboard
copy the token and paste it into the Enter token field on the login screen.

# Uninstall
helm -n kubernetes-dashboard uninstall kubernetes-dashboard
