#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/5
sudo chmod 777 /opt/course/5
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating ServiceAccount..."
kubectl -n neptune create serviceaccount neptune-sa-v2 --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Secret with token..."
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: neptune-secret-1
  namespace: neptune
  annotations:
    kubernetes.io/service-account.name: neptune-sa-v2
type: kubernetes.io/service-account-token
YAML

sleep 2
echo "[SETUP] Environment ready!"
