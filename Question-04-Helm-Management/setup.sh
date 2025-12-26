#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace mercury --dry-run=client -o yaml | kubectl apply -f -

if ! command -v helm &> /dev/null; then
    echo "[WARN] Helm is not installed. Please install helm to complete this question."
    exit 0
fi

echo "[SETUP] Adding helm repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
helm repo update

echo "[SETUP] Installing helm releases (this may take a minute)..."
# Release 1: to be deleted
helm upgrade --install internal-issue-report-apiv1 bitnami/nginx \
    -n mercury --version 15.0.0 --wait --timeout 120s 2>/dev/null || \
    echo "[WARN] Could not install internal-issue-report-apiv1"

# Release 2: to be upgraded  
helm upgrade --install internal-issue-report-apiv2 bitnami/nginx \
    -n mercury --version 15.0.0 --wait --timeout 120s 2>/dev/null || \
    echo "[WARN] Could not install internal-issue-report-apiv2"

# Release 3: working release
helm upgrade --install internal-issue-report-app bitnami/nginx \
    -n mercury --version 15.0.0 --wait --timeout 120s 2>/dev/null || \
    echo "[WARN] Could not install internal-issue-report-app"

echo "[SETUP] Environment ready!"
echo "[INFO] Note: pending-install release simulation not possible - skip step 4"
