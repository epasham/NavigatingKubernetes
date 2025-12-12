#!/bin/bash
. $(pwd)/../../../../scripts/common/init.sh

print_header "Installing ALG(Alloy+Loki+Grafana) Stack"

# Check if grafana repo exists
# helm repo add grafana https://grafana.github.io/helm-charts && helm repo update
if ! helm repo list | grep -q "grafana.github.io"; then
    echo "[INFO] Adding grafana helm repository..."
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
else
    echo "[INFO] grafana helm repository is already present"
fi

print_header "Installing Loki"
helm upgrade --install  loki grafana/loki -n observability --create-namespace -f loki-values.yaml


print_header "installing Grafana dashboard"
helm upgrade --Install grafana grafana/grafana -n observability --create-namespace -f grafana-values.yaml --wait


print_header "Install Grafana Alloy"
helm upgrade --install alloy grafana/k8s-monitoring -n observability --create-namespace -f alloy-values.yaml --wait


print_header "admin password: $(kubectl get secret --namespace grafana grafana-dashboard -o jsonpath="{.data.admin-password}" | base64 --decode)"
print_header "kubectl -n observability port-forward --address 0.0.0.0 svc/grafana 8080:80 &"
