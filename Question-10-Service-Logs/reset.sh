#!/bin/bash
echo "[RESET] Cleaning up Question 10..."
kubectl -n pluto delete pod project-plt-6cc-api --force --grace-period=0 2>/dev/null || true
kubectl -n pluto delete svc project-plt-6cc-svc 2>/dev/null || true
rm -f /opt/course/10/service_test.html /opt/course/10/service_test.log
echo "[RESET] Done!"
