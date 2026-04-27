kubectl port-forward --address 0.0.0.0 svc/qdrant-service 8080:6333 &

curl localhost:8080/dashboard
