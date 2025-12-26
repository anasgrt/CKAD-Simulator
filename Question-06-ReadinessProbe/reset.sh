#!/bin/bash
echo "[RESET] Cleaning up Question 6..."
kubectl delete pod pod6 --force --grace-period=0 2>/dev/null || true
rm -f /tmp/6.yaml
echo "[RESET] Done!"
