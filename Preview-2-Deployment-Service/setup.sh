#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/p2
sudo chmod 777 /opt/course/p2
kubectl create namespace sun --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating ServiceAccount..."
kubectl -n sun create serviceaccount sa-sun-deploy --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Environment ready!"
