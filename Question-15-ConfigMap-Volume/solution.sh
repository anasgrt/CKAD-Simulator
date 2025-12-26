#!/bin/bash
# Solution for Question 15 - ConfigMap, Configmap-Volume

echo "# Step 1: Create ConfigMap from file with specific key"
kubectl -n moon create configmap configmap-web-moon-html \
    --from-file=index.html=/opt/course/15/web-moon.html

echo ""
echo "# Step 2: Wait for pods to start"
sleep 5
kubectl -n moon get pod

echo ""
echo "# Step 3: Test with curl"
POD_IP=$(kubectl -n moon get pod -l app=web-moon -o jsonpath='{.items[0].status.podIP}')
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s http://$POD_IP
