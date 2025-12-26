#!/bin/bash
echo "[RESET] Cleaning up Question 19..."
kubectl -n jupiter delete deployment jupiter-crew-deploy --force --grace-period=0 2>/dev/null || true
kubectl -n jupiter delete svc jupiter-crew-svc 2>/dev/null || true
echo "[RESET] Done!"
