#!/bin/bash
# Solution for Question 13 - StorageClass, PVC

echo "# Step 1: Create StorageClass"
cat <<YAML | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: moon-retain
provisioner: moon-retainer
reclaimPolicy: Retain
YAML

echo ""
echo "# Step 2: Create PersistentVolumeClaim"
cat <<YAML | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: moon-pvc-126
  namespace: moon
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
  storageClassName: moon-retain
YAML

echo ""
echo "# Step 3: Get PVC events and save reason"
sleep 2
kubectl -n moon describe pvc moon-pvc-126 | grep -A 5 "Events:" | tail -3 > /opt/course/13/pvc-126-reason
cat /opt/course/13/pvc-126-reason
