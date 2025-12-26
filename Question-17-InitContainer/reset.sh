#!/bin/bash
echo "[RESET] Cleaning up Question 17..."
kubectl -n mars delete deployment test-init-container --force --grace-period=0 2>/dev/null || true
echo "[RESET] Done!"
