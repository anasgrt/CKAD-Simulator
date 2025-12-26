#!/bin/bash
echo "[RESET] Cleaning up Preview 3..."
kubectl -n earth delete deployment earth-3cc-web --force --grace-period=0 2>/dev/null || true
kubectl -n earth delete svc earth-3cc-web 2>/dev/null || true
rm -f /opt/course/p3/ticket-654.txt
echo "[RESET] Done!"
