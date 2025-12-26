#!/bin/bash
echo "[SETUP] Creating namespace and directories..."
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f -
sudo mkdir -p /Volumes/Data
sudo chmod 777 /Volumes/Data
echo "[SETUP] Environment ready!"
