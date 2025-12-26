#!/bin/bash
echo "[RESET] Cleaning up Question 3..."
kubectl delete job neb-new-job -n neptune --force --grace-period=0 2>/dev/null || true
rm -f /opt/course/3/job.yaml
echo "[RESET] Done!"
