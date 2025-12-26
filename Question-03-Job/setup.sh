#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/3
sudo chmod 777 /opt/course/3
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -
echo "[SETUP] Environment ready!"
