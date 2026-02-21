#!/bin/bash
# ============================================================
# CNCF Project Focus #4: Prometheus
# Cleanup script - removes all deployed resources
# ============================================================

set -euo pipefail

NAMESPACE="monitoring"
RELEASE_NAME="kube-prometheus-stack"
CLUSTER_NAME="prometheus-lab"

echo "🗑️  CNCF Project Focus #4: Prometheus Cleanup"
echo "============================================"
echo ""

# Remove sample workloads
echo "📦 Removing sample workloads..."
kubectl delete namespace demo --ignore-not-found

# Remove Kyverno policies
echo "🛡️  Removing Kyverno policies..."
kubectl delete -f ../kyverno-policies/ --ignore-not-found 2>/dev/null || true

# Uninstall Kyverno
if helm list -n kyverno 2>/dev/null | grep -q kyverno; then
  echo "🛡️  Uninstalling Kyverno..."
  helm uninstall kyverno -n kyverno
  kubectl delete namespace kyverno --ignore-not-found
fi

# Uninstall kube-prometheus-stack
echo "🔥 Uninstalling ${RELEASE_NAME}..."
helm uninstall "${RELEASE_NAME}" -n "${NAMESPACE}" --ignore-not-found

# Remove monitoring namespace
echo "📦 Removing namespace '${NAMESPACE}'..."
kubectl delete namespace "${NAMESPACE}" --ignore-not-found

echo ""
echo "✅ Cluster resources removed."
echo ""

# Optionally delete the Minikube cluster
read -p "Delete Minikube cluster '${CLUSTER_NAME}'? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "🗑️  Deleting Minikube cluster..."
  minikube delete -p "${CLUSTER_NAME}"
  echo "✅ Cluster deleted."
else
  echo "ℹ️  Cluster kept. Run 'minikube stop -p ${CLUSTER_NAME}' to stop it."
fi

echo ""
echo "============================================"
echo "✅ Cleanup complete!"
echo "============================================"
