#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/p1
sudo chmod 777 /opt/course/p1
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Deployment yaml..."
cat > /opt/course/p1/project-23-api.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-23-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      app: project-23-api
  template:
    metadata:
      labels:
        app: project-23-api
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        env:
        - name: APP_ENV
          value: "prod"
YAML

echo "[SETUP] Creating Deployment..."
kubectl apply -f /opt/course/p1/project-23-api.yaml

echo "[SETUP] Environment ready!"
