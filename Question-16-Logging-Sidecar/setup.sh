#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/16
sudo chmod 777 /opt/course/16
kubectl create namespace mercury --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Deployment yaml..."
cat > /opt/course/16/cleaner.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
      - name: logs
        emptyDir: {}
      initContainers:
      - name: init
        image: bash:5.0.11
        command: ['bash', '-c', 'echo init > /var/log/cleaner/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      containers:
      - name: cleaner-con
        image: bash:5.0.11
        args: ['bash', '-c', 'while true; do echo `date`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
YAML

echo "[SETUP] Creating Deployment..."
kubectl apply -f /opt/course/16/cleaner.yaml

echo "[SETUP] Environment ready!"
