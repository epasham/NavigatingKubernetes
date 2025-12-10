# add helm repo
helm repo add fluent https://fluent.github.io/helm-charts && helm repo update
helm search repo fluent

# lookup fluent-bit available chart versions
helm search repo fluent/fluent-bit --versions

helm show values fluent/fluent-bit --version 0.50.0
OR
helm inspect values fluent/fluent-bit --version 0.50.0

helm inspect values fluent/fluent-bit --version 0.50.0 > fluent-bit-values.yaml

# to debug
logLevel: info

[OUTPUT]
  Name null
  Match *
  
# Install fluent-bit
helm upgrade --install fluent-bit fluent/fluent-bit -n observability --create-namespace -f values.yaml --version 0.50.0
