# 🧪 Example Workloads

Sample applications to test Prometheus metrics collection and Kyverno policy enforcement.

## Sample App (`sample-app.yaml`)

A properly configured application with:
- CPU and memory requests and limits
- All required cost labels (`team`, `project`, `environment`)
- Realistic resource allocations

This workload should **pass** all Kyverno policies.

## Over-Provisioned App (`overprovisioned-app.yaml`)

A deliberately wasteful application with:
- Excessive resource limits (10x what it needs)
- Low actual resource consumption
- All required labels (to pass Kyverno)

Use this to test waste detection PromQL queries and validate that Grafana dashboards correctly highlight over-provisioned workloads.

## Usage

```bash
# Deploy both examples
kubectl apply -f sample-app.yaml
kubectl apply -f overprovisioned-app.yaml

# Wait for pods to be running
kubectl get pods -n demo -w

# After ~5 minutes, check Prometheus for metrics
# The over-provisioned app should show < 15% CPU utilization
```

## Cleanup

```bash
kubectl delete namespace demo
```
