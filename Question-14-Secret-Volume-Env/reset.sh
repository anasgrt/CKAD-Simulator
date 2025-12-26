#!/bin/bash
echo "[RESET] Cleaning up Question 14..."
kubectl -n moon delete pod secret-handler --force --grace-period=0 2>/dev/null || true
kubectl -n moon delete secret secret1 2>/dev/null || true
kubectl -n moon delete secret secret2 2>/dev/null || true
rm -f /opt/course/14/secret-handler-new.yaml
echo "[RESET] Done!"
