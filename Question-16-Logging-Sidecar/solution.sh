#!/bin/bash
# Solution for Question 16 - Logging Sidecar

echo "# Step 1: Create new yaml with sidecar container"
cat > /opt/course/16/cleaner-new.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
      - name: logs
        emptyDir: {}
      initContainers:
      - name: init
        image: bash:5.0.11
        command: ['bash', '-c', 'echo init > /var/log/cleaner/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      - name: logger-con
        image: busybox:1.31.0
        restartPolicy: Always
        command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"]
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      containers:
      - name: cleaner-con
        image: bash:5.0.11
        args: ['bash', '-c', 'while true; do echo `date`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
YAML

echo ""
echo "# Step 2: Apply changes"
kubectl apply -f /opt/course/16/cleaner-new.yaml

echo ""
echo "# Step 3: Wait and check logs"
sleep 5
POD=$(kubectl -n mercury get pod -l id=cleaner -o jsonpath='{.items[0].metadata.name}')
kubectl -n mercury logs $POD -c logger-con | head -10
