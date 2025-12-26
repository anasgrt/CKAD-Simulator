#!/bin/bash
echo "[RESET] Cleaning up Question 20..."
kubectl -n venus delete networkpolicy np1 2>/dev/null || true
kubectl -n venus delete deployment api frontend --force --grace-period=0 2>/dev/null || true
kubectl -n venus delete svc api frontend 2>/dev/null || true
echo "[RESET] Done!"
