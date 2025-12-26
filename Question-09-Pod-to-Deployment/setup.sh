#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/9
sudo chmod 777 /opt/course/9
kubectl create namespace pluto --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating Pod yaml file..."
cat > /opt/course/9/holy-api-pod.yaml << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: holy-api
  name: holy-api
  namespace: pluto
spec:
  containers:
  - env:
    - name: CACHE_KEY_1
      value: b&MTCi0=[T66RXm!jO@
    - name: CACHE_KEY_2
      value: PCAILGej5Ld@Q%{Q1=#
    - name: CACHE_KEY_3
      value: 2qz-]2OJlWDSTn_;RFQ
    image: nginx:1.17.3-alpine
    name: holy-api-container
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
YAML

echo "[SETUP] Creating the Pod..."
kubectl apply -f /opt/course/9/holy-api-pod.yaml

echo "[SETUP] Environment ready!"
