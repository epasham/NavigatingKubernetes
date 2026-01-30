# setup minio
cd kubernetes/minio
k create ns observability
k apply -f minio-standalone.yaml -n observability
k apply -f minio-client-job.yaml -n observability
k -n observability port-forward svc/minio --address 0.0.0.0  9001:9001 &

# setup tempo
cd kubernetes/observability/temp0
helm repo add grafana https://grafana.github.io/helm-charts && helm repo update
helm show values grafana/tempo-distributed > tempo-values.yaml
helm template tempo-dist grafana/tempo-distributed -n observability -f custom.yaml
helm upgrade --install tempo-dist grafana/tempo-distributed -n observability \
--create-namespace -f custom.yaml
