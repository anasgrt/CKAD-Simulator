#!/bin/bash
# Solution for Preview 3 - Debugging Service

echo "# Step 1: Check all resources"
kubectl -n earth get all

echo ""
echo "# Step 2: Check endpoints"
kubectl -n earth get endpoints

echo ""
echo "# Step 3: Check pods not ready"
kubectl -n earth get pod | grep -v "1/1"

echo ""
echo "# Step 4: Describe a not-ready pod"
POD=$(kubectl -n earth get pod -l id=earth-3cc-web -o jsonpath='{.items[0].metadata.name}')
kubectl -n earth describe pod $POD | grep -A 5 "Readiness"

echo ""
echo "# Problem: readiness probe on port 82, but nginx listens on port 80"

echo ""
echo "# Step 5: Fix the probe"
kubectl -n earth patch deployment earth-3cc-web --type=json \
    -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/readinessProbe/tcpSocket/port", "value": 80}]'

echo ""
echo "# Step 6: Write reason"
echo "Wrong port for readinessProbe defined! Port 82 instead of 80." > /opt/course/p3/ticket-654.txt

echo ""
echo "# Wait and verify:"
sleep 15
kubectl -n earth get pod -l id=earth-3cc-web
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s http://earth-3cc-web.earth:6363 | head -3
