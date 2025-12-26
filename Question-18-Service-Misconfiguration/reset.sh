#!/bin/bash
echo "[RESET] Cleaning up Question 18..."
kubectl -n mars delete deployment manager-api-deployment --force --grace-period=0 2>/dev/null || true
kubectl -n mars delete svc manager-api-svc 2>/dev/null || true
echo "[RESET] Done!"
