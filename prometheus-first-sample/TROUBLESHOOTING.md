# Troubleshooting Guide

---

## Time drift — Prometheus warning "out of order samples"

**Symptom:** Prometheus UI shows a warning: `Error: 1 errors occurred: ... out of order samples`. No data appears in dashboards despite the stack running correctly.

**Root cause:** WSL2, the Minikube VM, and Windows have independent clocks. WSL2 clock drifts after the host sleeps or resumes, causing Prometheus to reject metrics with timestamps in the future or past.

**Fix:** Sync all three clocks in order:

1. **Sync Windows** (Settings → Time & Language → Date & Time → Sync now)

2. **Sync WSL2:**
   ```bash
   sudo date -s "$(curl -sI google.com | grep -i '^date:' | cut -d' ' -f2-)"
   ```

3. **Sync Minikube VM:**
   ```bash
   minikube ssh -p prometheus-lab "sudo date -s '$(date -u)'"
   ```

4. **Restart Prometheus** to clear the stale state:
   ```bash
   kubectl rollout restart statefulset/prometheus-kube-prometheus-stack-prometheus -n monitoring
   ```

> **Note:** This sync is needed each time WSL2 resumes from a Windows sleep/hibernate. It is not persistent.
