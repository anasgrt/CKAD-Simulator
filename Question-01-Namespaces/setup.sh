#!/bin/bash
# Question 1 Setup - Namespaces

echo "[SETUP] Creating directories..."
sudo mkdir -p /opt/course/1
sudo chmod 777 /opt/course/1

echo "[SETUP] Creating prerequisite namespaces..."
kubectl create namespace earth --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null
kubectl create namespace jupiter --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null
kubectl create namespace mars --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null
kubectl create namespace shell-intern --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null

echo "[SETUP] Environment ready!"
