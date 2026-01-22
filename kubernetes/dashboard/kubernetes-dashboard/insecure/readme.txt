# Allow insecure access by skipping the authentication process
############

# expose the dashboard UI
POD_NAME=$(k -n kubernetes-dashboard get pods -l "k8s-app=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")
k -n kubernetes-dashboard port-forward --address 0.0.0.0 $POD_NAME 9000:9090 &

############
# Create user
############
k apply -f create-admin-user.yaml

# Create token that is used to log in
k -n kubernetes-dashboard create token admin-user

It should print something like:
eyJhbGciOiJSUzI1NiIsImtpZCI6ImxWVkdHNVkzWHgzeU8xZDdldmpWZXBVQmJLaXBvLUFuR2U2TlZ6MXZRY3cifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNzY5MDc4MjkzLCJpYXQiOjE3NjkwNzQ2OTMsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwianRpIjoiNDAwNTRiNTQtYzBhYS00ZGZlLWIzZTgtNWIwMTFjZTQxODM4Iiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJhZG1pbi11c2VyIiwidWlkIjoiZWFhOTUxM2MtYTg0OS00YTdkLTlmNTgtOWNmNzQ3YzFkZjdjIn19LCJuYmYiOjE3NjkwNzQ2OTMsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbi11c2VyIn0.PAPwiwkh8TrShjoJZ8aaj-1Hl1pNgtRh3_Bi1m-NQLuuKDP_Tc_s4Owf1M016Z9VFI8NZtvZ16OO7OjI5FLNlr-4Igj34TCpvMgC2pNvxVaQowxiN4FFeZgo6Pc9UWInklTp-EzUZhEpjOJ9AznyeiSGyZbxcXI9qV-UbSghtzSCvRO7cGN2jfxDJcaLqUeYpO-TXJQT7PxEcICPaXLpQ5R0h5Iu1lcwb5Z5KShpaAkWJy6mHmhHCbYUE9R-qGrnkw2KKsoR7LqBR6SaKjULikZJNTdizqgZd1X8ONFb_FBlWNhlB1OxFgop79Zkqn9xhgV27AZQNV2q6Wd5a1TNrQ


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

## Cleanup
# Remove the admin ServiceAccount and ClusterRoleBinding.
k -n kubernetes-dashboard delete serviceaccount admin-user
k -n kubernetes-dashboard delete clusterrolebinding admin-user
