#!/bin/bash
echo "[RESET] Cleaning up Preview 2..."
kubectl -n sun delete deployment sunny --force --grace-period=0 2>/dev/null || true
kubectl -n sun delete svc sun-srv 2>/dev/null || true
rm -f /opt/course/p2/sunny_status_command.sh
echo "[RESET] Done!"
