#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/17
sudo chmod 777 /opt/course/17
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Deployment yaml..."
cat > /opt/course/17/test-init-container.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
YAML

echo "[SETUP] Environment ready!"
