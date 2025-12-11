# helm repo add grafana https://grafana.github.io/helm-charts && helm repo update

# Check if grafana repo exists
if ! helm repo list | grep -q "grafana.github.io"; then
    echo "[INFO] Adding grafana helm repository..."
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
else
    echo "[INFO] grafana helm repository is already present"
fi
