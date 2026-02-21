# 🛡️ Kyverno Policies for Cost Governance

These policies enforce cost optimization best practices at the admission level, ensuring Prometheus metrics are always meaningful and actionable.

## Why Kyverno + Prometheus?

Without Kyverno, Prometheus collects metrics from pods that may lack resource limits or cost labels. This makes cost attribution impossible and utilization metrics meaningless.

With Kyverno enforcing standards at deployment time, every pod entering the cluster has the metadata Prometheus needs for accurate cost visibility.

## Policies

| Policy | Type | Purpose |
|--------|------|---------|
| `require-resource-limits.yaml` | Validate | Ensure every container has CPU and memory requests and limits |
| `require-cost-labels.yaml` | Validate | Mandate `team`, `project`, and `environment` labels |
| `validate-resource-ratios.yaml` | Validate | Prevent extreme over-provisioning (limit/request ratio) |
| `generate-cost-report.yaml` | Mutate | Auto-add cost-tracking annotations to new pods |

## Installation

### Prerequisites

```bash
# Install Kyverno
helm repo add kyverno https://kyverno.github.io/kyverno/
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
```

### Apply Policies

```bash
# Apply all policies
kubectl apply -f .

# Or apply individually
kubectl apply -f require-resource-limits.yaml
kubectl apply -f require-cost-labels.yaml
kubectl apply -f validate-resource-ratios.yaml
kubectl apply -f generate-cost-report.yaml
```

### Verify

```bash
# Check policy status
kubectl get clusterpolicy

# View policy reports
kubectl get policyreport -A
```

## Testing

```bash
# This should be BLOCKED (no resource limits):
kubectl run test-no-limits --image=nginx

# This should PASS:
kubectl apply -f ../examples/sample-app.yaml
```

## Monitoring Policy Compliance with Prometheus

Kyverno exposes metrics that Prometheus can scrape:

```promql
# Total policy violations
kyverno_policy_results_total{rule_result="fail"}

# Violations by policy
sum by (policy_name) (kyverno_policy_results_total{rule_result="fail"})

# Compliance rate
sum(kyverno_policy_results_total{rule_result="pass"})
/
sum(kyverno_policy_results_total) * 100
```
