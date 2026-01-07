helm repo add grafana https://grafana.github.io/helm-charts && helm repo update

helm show values grafana/tempo-distributed > tempo-values.yaml
helm template tempo-dist grafana/tempo-distributed -n observability -f custom.yaml
helm upgrade --install tempo-dist grafana/tempo-distributed -n observability \
--create-namespace -f custom.yaml
