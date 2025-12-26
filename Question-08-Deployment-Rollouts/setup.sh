#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating deployment with working image..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-new-c32
  namespace: neptune
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-new-c32
  template:
    metadata:
      labels:
        app: api-new-c32
    spec:
      containers:
      - name: nginx
        image: nginx:1.16.1-alpine
YAML

echo "[SETUP] Waiting for deployment..."
kubectl -n neptune rollout status deployment/api-new-c32 --timeout=60s 2>/dev/null || true

echo "[SETUP] Creating revision history with broken image..."
kubectl -n neptune set image deployment/api-new-c32 nginx=nginx:1.17.3-alpine
sleep 2
kubectl -n neptune set image deployment/api-new-c32 nginx=nginx:1.17.6-alpine
sleep 2
kubectl -n neptune set image deployment/api-new-c32 nginx=nginx:1.18.0-alpine
sleep 2
# Broken image (typo: ngnix instead of nginx)
kubectl -n neptune set image deployment/api-new-c32 nginx=ngnix:1-alpine

echo "[SETUP] Environment ready!"
echo "[INFO] Deployment has a broken revision with typo in image name"
