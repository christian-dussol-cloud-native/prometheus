# 🚀 Setup Guide

## Quick Start

Run the install script to deploy the full Prometheus monitoring stack:

```bash
chmod +x install.sh
./install.sh
```

## What Gets Installed

The script deploys **kube-prometheus-stack** via Helm, which includes:

- **Prometheus Server** — metrics collection and storage
- **Grafana** — visualization and dashboards
- **Alertmanager** — alert routing and notification
- **Node Exporter** — host-level metrics
- **kube-state-metrics** — Kubernetes object metrics

## Custom Configuration

The `values.yaml` file includes cost-optimization defaults:

- Reduced retention (7 days for local clusters)
- Resource limits on Prometheus itself
- Pre-configured scrape intervals
- Grafana provisioned with admin access

## Accessing Services

After installation:

```bash
# Prometheus UI
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring

# Grafana (admin / prom-operator)
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring

# Alertmanager
kubectl port-forward svc/kube-prometheus-stack-alertmanager 9093:9093 -n monitoring
```

## Cleanup

Run the cleanup script to remove all deployed resources:

```bash
chmod u+x cleanup.sh
./cleanup.sh
```

The script removes sample workloads, Kyverno, kube-prometheus-stack, and optionally deletes the Minikube cluster.
