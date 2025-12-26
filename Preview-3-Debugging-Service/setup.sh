#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/p3
sudo chmod 777 /opt/course/p3
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating working deployments..."
for name in earth-2x3-api earth-2x3-web earth-3cc-runner earth-3cc-runner-heavy; do
    kubectl -n earth create deployment $name --image=nginx:1.17.3-alpine --replicas=3 2>/dev/null || true
done

echo "[SETUP] Creating services..."
kubectl -n earth expose deployment earth-2x3-api --name earth-2x3-api-svc --port 4546 --target-port 80 2>/dev/null || true
kubectl -n earth expose deployment earth-2x3-web --name earth-2x3-web-svc --port 4545 --target-port 80 2>/dev/null || true

echo "[SETUP] Creating BROKEN deployment (wrong readiness probe port)..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: earth-3cc-web
  namespace: earth
spec:
  replicas: 4
  selector:
    matchLabels:
      id: earth-3cc-web
  template:
    metadata:
      labels:
        id: earth-3cc-web
    spec:
      containers:
      - name: nginx
        image: nginx:1-alpine
        ports:
        - containerPort: 80
        readinessProbe:
          tcpSocket:
            port: 82
          initialDelaySeconds: 10
          periodSeconds: 20
---
apiVersion: v1
kind: Service
metadata:
  name: earth-3cc-web
  namespace: earth
spec:
  ports:
  - port: 6363
    targetPort: 80
  selector:
    id: earth-3cc-web
YAML

echo "[SETUP] Environment ready!"
echo "[INFO] earth-3cc-web has broken readiness probe (port 82 instead of 80)"
