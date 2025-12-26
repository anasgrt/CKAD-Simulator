#!/bin/bash
echo "[RESET] Cleaning up Question 15..."
kubectl -n moon delete configmap configmap-web-moon-html 2>/dev/null || true
kubectl -n moon rollout restart deployment web-moon 2>/dev/null || true
echo "[RESET] Done!"
