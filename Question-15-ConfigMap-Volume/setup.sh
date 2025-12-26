#!/bin/bash
echo "[SETUP] Creating directories and namespace..."
sudo mkdir -p /opt/course/15
sudo chmod 777 /opt/course/15
kubectl create namespace moon --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating HTML file..."
cat > /opt/course/15/web-moon.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Web Moon Webpage</title>
</head>
<body>
This is some great content.
</body>
</html>
HTML

echo "[SETUP] Creating Deployment waiting for ConfigMap..."
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-moon
  namespace: moon
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-moon
  template:
    metadata:
      labels:
        app: web-moon
    spec:
      volumes:
      - name: html-volume
        configMap:
          name: configmap-web-moon-html
      containers:
      - name: nginx
        image: nginx:1.17.3-alpine
        volumeMounts:
        - name: html-volume
          mountPath: /usr/share/nginx/html
YAML

echo "[SETUP] Environment ready!"
echo "[INFO] Pods will be in ContainerCreating until ConfigMap is created"
