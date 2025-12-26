#!/bin/bash
echo "[SETUP] Creating namespaces..."
kubectl create namespace saturn --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace neptune --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating webserver pods in saturn..."
for i in 001 002 003 004 005 006; do
    ANNOTATION=""
    if [ "$i" == "003" ]; then
        ANNOTATION='annotations:
    description: "this is the server for the E-Commerce System my-happy-shop"'
    fi
    
    cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: webserver-sat-$i
  namespace: saturn
  labels:
    id: webserver-sat-$i
  $ANNOTATION
spec:
  containers:
  - name: webserver-sat
    image: nginx:1.16.1-alpine
YAML
done

echo "[SETUP] Environment ready!"
echo "[INFO] 6 webserver pods created in saturn namespace"
