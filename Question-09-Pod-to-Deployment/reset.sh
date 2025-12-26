#!/bin/bash
echo "[RESET] Cleaning up Question 9..."
kubectl delete deployment holy-api -n pluto --force --grace-period=0 2>/dev/null || true
kubectl delete pod holy-api -n pluto --force --grace-period=0 2>/dev/null || true
rm -f /opt/course/9/holy-api-deployment.yaml
echo "[RESET] Done!"
