#!/bin/bash
. $(pwd)/../../../../scripts/common/init.sh

print_header "Installing FLG(Fluent-bit+Loki+Grafana) Stack"

# Check if grafana repo exists
# helm repo add grafana https://grafana.github.io/helm-charts && helm repo update
if ! helm repo list | grep -q "grafana.github.io"; then
    echo "[INFO] Adding grafana helm repository..."
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
else
    echo "[INFO] grafana helm repository is already present"
fi

print_header "installing Loki"
helm upgrade --install  loki grafana/loki -n observability --create-namespace -f ../ALG-stack/loki-values.yml


print_header "installing Grafana dashboard"
helm upgrade --install grafana grafana/grafana -n observability --create-namespace -f ../ALG-stack/grafana-values.yml --wait


print_header "install Fluent-bit"
helm repo add fluent https://fluent.github.io/helm-charts && helm repo update
helm upgrade --install fluent-bit fluent/fluent-bit -n observability --create-namespace -f fluent-bit-values.yaml --version 0.50.0

print_header "admin password: $(kubectl get secret --namespace grafana grafana-dashboard -o jsonpath="{.data.admin-password}" | base64 --decode)"
print_header "kubectl -n observability port-forward --address 0.0.0.0 svc/grafana 8080:80 &"
