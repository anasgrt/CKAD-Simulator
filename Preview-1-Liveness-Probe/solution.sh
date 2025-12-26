#!/bin/bash
# Solution for Preview 1 - Liveness Probe

cat > /opt/course/p1/project-23-api-new.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-23-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      app: project-23-api
  template:
    metadata:
      labels:
        app: project-23-api
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        env:
        - name: APP_ENV
          value: "prod"
        livenessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 15
YAML

kubectl apply -f /opt/course/p1/project-23-api-new.yaml

echo "# Verify:"
sleep 5
kubectl -n pluto describe deployment project-23-api | grep -A 3 Liveness
