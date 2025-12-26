#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Deployment..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manager-api-deployment
  namespace: mars
spec:
  replicas: 4
  selector:
    matchLabels:
      id: manager-api-pod
  template:
    metadata:
      labels:
        id: manager-api-pod
    spec:
      containers:
      - name: nginx
        image: nginx:1.17.3-alpine
        ports:
        - containerPort: 80
YAML

sleep 3

echo "[SETUP] Creating MISCONFIGURED Service..."
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: manager-api-svc
  namespace: mars
spec:
  type: ClusterIP
  ports:
  - port: 4444
    targetPort: 80
  selector:
    id: manager-api-deployment
YAML

echo "[SETUP] Environment ready!"
echo "[INFO] Service has WRONG selector - points to deployment name instead of pod label"
