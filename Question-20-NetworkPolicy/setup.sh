#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace venus --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating API Deployment and Service..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: venus
spec:
  replicas: 2
  selector:
    matchLabels:
      id: api
  template:
    metadata:
      labels:
        id: api
    spec:
      containers:
      - name: httpd
        image: httpd:2.4-alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: venus
spec:
  ports:
  - port: 2222
    targetPort: 80
  selector:
    id: api
YAML

echo "[SETUP] Creating Frontend Deployment and Service..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: venus
spec:
  replicas: 2
  selector:
    matchLabels:
      id: frontend
  template:
    metadata:
      labels:
        id: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:1.17.3-alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: venus
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    id: frontend
YAML

echo "[SETUP] Environment ready!"
