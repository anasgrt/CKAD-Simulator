#!/bin/bash
echo "[RESET] Cleaning up Question 13..."
kubectl -n moon delete pvc moon-pvc-126 2>/dev/null || true
kubectl delete storageclass moon-retain 2>/dev/null || true
rm -f /opt/course/13/pvc-126-reason
echo "[RESET] Done!"
