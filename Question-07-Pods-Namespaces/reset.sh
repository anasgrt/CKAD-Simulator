#!/bin/bash
echo "[RESET] Cleaning up Question 7..."
kubectl delete pod webserver-sat-003 -n neptune --force --grace-period=0 2>/dev/null || true
for i in 001 002 003 004 005 006; do
    kubectl delete pod webserver-sat-$i -n saturn --force --grace-period=0 2>/dev/null || true
done
rm -f /tmp/7.yaml
echo "[RESET] Done!"
