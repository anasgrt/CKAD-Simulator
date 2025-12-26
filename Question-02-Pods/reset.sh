#!/bin/bash
echo "[RESET] Cleaning up Question 2..."
kubectl delete pod pod1 -n default --force --grace-period=0 2>/dev/null || true
rm -f /opt/course/2/pod1-status-command.sh
rm -f /tmp/2.yaml
echo "[RESET] Done!"
