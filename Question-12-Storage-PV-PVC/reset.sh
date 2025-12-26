#!/bin/bash
echo "[RESET] Cleaning up Question 12..."
kubectl -n earth delete deployment project-earthflower --force --grace-period=0 2>/dev/null || true
kubectl -n earth delete pvc earth-project-earthflower-pvc 2>/dev/null || true
kubectl delete pv earth-project-earthflower-pv 2>/dev/null || true
echo "[RESET] Done!"
