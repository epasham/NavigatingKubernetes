#!/usr/bin/env bash
set -euo pipefail

# --------- Configuration ---------
AAD_GROUP_ID="<aad-group-object-id>"        # e.g., 00000000-0000-0000-0000-000000000000
CLUSTER_ROLE_NAME="developer-access"        # ClusterRole you created earlier
OUT_DIR="./rbac-rolebindings"               # Output directory for YAML files

# Optional: namespace exclusions (regex), add more if needed
EXCLUDE_REGEX='^(kube-system|kube-public|kube-node-lease|default|local-path-storage)$'

# --------- Prep ---------
mkdir -p "${OUT_DIR}"

# --------- Build namespace list excluding system ones ---------
mapfile -t nsList < <(
  kubectl get ns -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
  | grep -vE "${EXCLUDE_REGEX}"
)

if [[ ${#nsList[@]} -eq 0 ]]; then
  echo "No namespaces found (after exclusions). Nothing to generate."
  exit 0
else
  echo "[INFO] Following namespaces are found"
  echo ${nsList[*]}
fi

# --------- Generate RoleBinding YAML per namespace ---------
for ns in "${nsList[@]}"; do
  file="${OUT_DIR}/rolebinding-${ns}.yaml"
  cat > "${file}" <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${CLUSTER_ROLE_NAME}-binding
  namespace: ${ns}
subjects:
- kind: Group
  name: ${AAD_GROUP_ID}
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: ${CLUSTER_ROLE_NAME}
  apiGroup: rbac.authorization.k8s.io
EOF
  echo "~\~E Wrote ${file}"
done

echo
echo "All manifests generated in: ${OUT_DIR}"
echo "Validate (no changes): kubectl apply --dry-run=client -f ${OUT_DIR}/"
echo "Deploy when ready:      kubectl apply -f ${OUT_DIR}/"
