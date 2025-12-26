#!/bin/bash
echo "[SETUP] Creating namespace and ServiceAccount..."
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -
kubectl -n neptune create serviceaccount neptune-sa-v2 --dry-run=client -o yaml | kubectl apply -f -
echo "[SETUP] Environment ready!"
