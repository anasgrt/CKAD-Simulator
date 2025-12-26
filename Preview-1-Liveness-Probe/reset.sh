#!/bin/bash
echo "[RESET] Cleaning up Preview 1..."
kubectl apply -f /opt/course/p1/project-23-api.yaml 2>/dev/null || true
rm -f /opt/course/p1/project-23-api-new.yaml
echo "[RESET] Done!"
