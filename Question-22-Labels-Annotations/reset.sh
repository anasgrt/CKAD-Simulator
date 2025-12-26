#!/bin/bash
echo "[RESET] Cleaning up Question 22..."
kubectl -n sun delete pod --all --force --grace-period=0 2>/dev/null || true
echo "[RESET] Done!"
