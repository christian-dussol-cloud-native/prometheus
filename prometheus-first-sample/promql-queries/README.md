# 📊 PromQL Queries for Cost Optimization

This directory contains production-ready PromQL queries organized by purpose. Each query includes explanations and expected output.

## Prerequisites

These queries assume:
- **kube-prometheus-stack** is installed (provides `container_*` and `kube_*` metrics)
- Pods have **resource requests and limits** set (enforced by Kyverno policies in this repo)
- Pods have **cost labels** (`team`, `project`, `environment`)

## Query Files

| File | Purpose |
|------|---------|
| `cost-attribution.promql` | Track resource consumption per namespace, team, and project |
| `utilization.promql` | Measure how efficiently resources are used |
| `waste-detection.promql` | Identify over-provisioned and idle workloads |
| `capacity-planning.promql` | Forecast resource needs based on trends |
| `slo-monitoring.promql` | SLA/SLO compliance tracking |

## How to Use

1. Open **Prometheus UI** (`http://localhost:9090`) or **Grafana Explore**
2. Copy a query from any `.promql` file
3. Paste it into the query editor
4. Execute and analyze results

## Understanding the Metrics

Key metric sources used across these queries:

| Metric | Source | What It Measures |
|--------|--------|------------------|
| `container_cpu_usage_seconds_total` | cAdvisor | Actual CPU consumed |
| `container_memory_usage_bytes` | cAdvisor | Actual memory used |
| `kube_pod_container_resource_requests` | kube-state-metrics | Requested resources |
| `kube_pod_container_resource_limits` | kube-state-metrics | Resource limits |
| `kube_namespace_labels` | kube-state-metrics | Namespace metadata |
| `kube_pod_labels` | kube-state-metrics | Pod labels (team, project) |
