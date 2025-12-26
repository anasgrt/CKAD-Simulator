#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/14
sudo chmod 777 /opt/course/14
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating secret2.yaml..."
cat > /opt/course/14/secret2.yaml << 'YAML'
apiVersion: v1
kind: Secret
metadata:
  name: secret2
  namespace: moon
type: Opaque
data:
  key: MTIzNDU2Nzg=
YAML

echo "[SETUP] Creating secret-handler.yaml..."
cat > /opt/course/14/secret-handler.yaml << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
  name: secret-handler
  namespace: moon
spec:
  volumes:
  - name: cache-volume1
    emptyDir: {}
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    env:
    - name: SECRET_KEY_1
      value: ">8\$kH#kj..i8}HImQd{"
YAML

echo "[SETUP] Creating Pod..."
kubectl apply -f /opt/course/14/secret-handler.yaml

echo "[SETUP] Environment ready!"
