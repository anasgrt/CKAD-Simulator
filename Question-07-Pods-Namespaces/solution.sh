#!/bin/bash
# Solution for Question 7 - Pods, Namespaces

echo "# Step 1: Search for my-happy-shop"
kubectl -n saturn get pod -o yaml | grep my-happy-shop -B 20 | head -30

echo ""
echo "# Found: webserver-sat-003"

echo ""
echo "# Step 2: Export pod yaml"
kubectl -n saturn get pod webserver-sat-003 -o yaml > /tmp/7.yaml

echo ""
echo "# Step 3: Edit yaml - change namespace to neptune, remove status, nodeName, etc"
cat > /tmp/7.yaml << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  annotations:
    description: this is the server for the E-Commerce System my-happy-shop
  labels:
    id: webserver-sat-003
  name: webserver-sat-003
  namespace: neptune
spec:
  containers:
  - image: nginx:1.16.1-alpine
    name: webserver-sat
YAML

echo ""
echo "# Step 4: Create in neptune namespace"
kubectl apply -f /tmp/7.yaml

echo ""
echo "# Step 5: Delete from saturn namespace"
kubectl -n saturn delete pod webserver-sat-003 --force --grace-period=0

echo ""
echo "# Verify:"
kubectl get pod -A | grep webserver-sat-003
