#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace jupiter --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Deployment..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupiter-crew-deploy
  namespace: jupiter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jupiter-crew
  template:
    metadata:
      labels:
        app: jupiter-crew
    spec:
      containers:
      - name: httpd
        image: httpd:2.4-alpine
        ports:
        - containerPort: 80
YAML

echo "[SETUP] Creating ClusterIP Service..."
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: jupiter-crew-svc
  namespace: jupiter
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: jupiter-crew
YAML

echo "[SETUP] Environment ready!"
