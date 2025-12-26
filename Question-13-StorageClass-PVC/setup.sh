#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/13
sudo chmod 777 /opt/course/13
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -
echo "[SETUP] Environment ready!"
