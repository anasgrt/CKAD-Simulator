#!/bin/bash
# Solution for Question 12 - Storage, PV, PVC

echo "# Step 1: Create PersistentVolume"
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: earth-project-earthflower-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
YAML

echo ""
echo "# Step 2: Create PersistentVolumeClaim"
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
YAML

echo ""
echo "# Step 3: Create Deployment with volume mount"
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-earthflower
  namespace: earth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: project-earthflower
  template:
    metadata:
      labels:
        app: project-earthflower
    spec:
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: earth-project-earthflower-pvc
      containers:
      - image: httpd:2.4.41-alpine
        name: container
        volumeMounts:
        - name: data
          mountPath: /tmp/project-data
YAML

echo ""
echo "# Verify:"
kubectl -n earth get pv,pvc
kubectl -n earth get deployment project-earthflower
