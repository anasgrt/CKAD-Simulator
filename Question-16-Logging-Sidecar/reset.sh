#!/bin/bash
echo "[RESET] Cleaning up Question 16..."
kubectl apply -f /opt/course/16/cleaner.yaml 2>/dev/null || true
rm -f /opt/course/16/cleaner-new.yaml
echo "[RESET] Done!"
