#!/bin/bash
echo "[RESET] Cleaning up Question 8..."
kubectl delete deployment api-new-c32 -n neptune --force --grace-period=0 2>/dev/null || true
echo "[RESET] Done!"
