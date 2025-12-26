#!/bin/bash
# Solution for Question 21 - Requests and Limits, ServiceAccount

echo "# Create Deployment with all requirements"
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: neptune-10ab
  namespace: neptune
spec:
  replicas: 3
  selector:
    matchLabels:
      app: neptune-10ab
  template:
    metadata:
      labels:
        app: neptune-10ab
    spec:
      serviceAccountName: neptune-sa-v2
      containers:
      - image: httpd:2.4-alpine
        name: neptune-pod-10ab
        resources:
          requests:
            memory: 20Mi
          limits:
            memory: 50Mi
YAML

echo ""
echo "# Verify:"
kubectl -n neptune get pod -l app=neptune-10ab
