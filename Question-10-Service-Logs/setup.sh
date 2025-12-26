#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/10
sudo chmod 777 /opt/course/10
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -
echo "[SETUP] Environment ready!"
