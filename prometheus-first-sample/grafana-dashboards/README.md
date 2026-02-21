# 📈 Grafana Dashboards

## Import Instructions

1. Open Grafana (`http://localhost:3000`)
2. Login (default: `admin` / `prom-operator`)
3. Go to **Dashboards → Import**
4. Click **Upload JSON file**
5. Select the dashboard JSON file
6. Select your Prometheus data source
7. Click **Import**

## Available Dashboards

### Cost Overview Dashboard (`cost-overview.json`)

Provides namespace-level cost visibility:

- CPU usage per namespace (cores)
- Memory usage per namespace (GiB)
- Top 10 resource consumers
- Team-level resource attribution
- Over-provisioning indicators

### Resource Efficiency Dashboard (`resource-efficiency.json`)

Focuses on right-sizing and waste detection:

- CPU utilization vs limits (per pod)
- Memory utilization vs limits (per pod)
- Over-provisioned workloads list
- Idle pod detection
- Right-sizing recommendations (request/usage ratio)

## Customization

Dashboards use template variables for:
- `namespace` — filter by namespace
- `interval` — adjust time granularity

Modify the JSON files or edit directly in Grafana UI.
