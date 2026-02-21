#!/bin/bash
# ============================================================
# CNCF Project Focus #4: Prometheus
# Quick setup script for kube-prometheus-stack
# ============================================================

set -euo pipefail

NAMESPACE="monitoring"
RELEASE_NAME="kube-prometheus-stack"
CHART_VERSION="65.1.0"  # Pin version for reproducibility

echo "🔥 CNCF Project Focus #4: Prometheus Setup"
echo "============================================"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "❌ helm not found. Please install Helm v3 first."
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    echo "❌ No Kubernetes cluster found. Please start a cluster first."
    echo "   Options: minikube start | kind create cluster | k3d cluster create"
    exit 1
fi

echo "✅ All prerequisites met."
echo ""

# Create namespace
echo "📦 Creating namespace '${NAMESPACE}'..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Add Helm repo
echo "📥 Adding prometheus-community Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack
echo "🚀 Installing ${RELEASE_NAME}..."
helm upgrade --install "${RELEASE_NAME}" \
    prometheus-community/kube-prometheus-stack \
    --namespace "${NAMESPACE}" \
    --values values.yaml \
    --version "${CHART_VERSION}" \
    --wait \
    --timeout 5m

echo ""
echo "✅ Installation complete!"
echo ""
echo "============================================"
echo "📊 Access your services:"
echo ""
echo "  Prometheus:   kubectl port-forward svc/${RELEASE_NAME}-prometheus 9090:9090 -n ${NAMESPACE}"
echo "                → http://localhost:9090"
echo ""
echo "  Grafana:      kubectl port-forward svc/${RELEASE_NAME}-grafana 3000:80 -n ${NAMESPACE}"
echo "                → http://localhost:3000 (admin / prom-operator)"
echo ""
echo "  Alertmanager: kubectl port-forward svc/${RELEASE_NAME}-alertmanager 9093:9093 -n ${NAMESPACE}"
echo "                → http://localhost:9093"
echo ""
echo "============================================"
echo "📖 Next steps:"
echo "  1. Deploy sample workloads:  kubectl apply -f ../examples/"
echo "  2. Apply Kyverno policies:   kubectl apply -f ../kyverno-policies/"
echo "  3. Import Grafana dashboards: ../grafana-dashboards/*.json"
echo "  4. Try PromQL queries:        ../promql-queries/"
echo "============================================"
