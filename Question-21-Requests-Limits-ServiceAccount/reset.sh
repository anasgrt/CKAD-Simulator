#!/bin/bash
echo "[RESET] Cleaning up Question 21..."
kubectl -n neptune delete deployment neptune-10ab --force --grace-period=0 2>/dev/null || true
echo "[RESET] Done!"
