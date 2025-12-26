#!/bin/bash
echo "[SETUP] Creating namespace..."
kubectl create namespace sun --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating pods with various labels..."
POD_CONFIGS=(
    "0509649a:type=runner,type_old=messenger"
    "0509649b:type=worker"
    "1428721e:type=worker"
    "1428721f:type=worker"
    "43b9a:type=test"
    "4c09:type=worker"
    "4c35:type=worker"
    "4fe4:type=worker"
    "5555a:type=messenger"
    "86cda:type=runner"
    "8d1c:type=messenger"
    "a004a:type=runner"
    "a94128196:type=runner,type_old=messenger"
    "afd79200c56a:type=worker"
    "b667:type=worker"
    "fdb2:type=worker"
)

for config in "${POD_CONFIGS[@]}"; do
    name="${config%%:*}"
    labels="${config#*:}"
    
    kubectl -n sun run $name --image=nginx:alpine --labels="$labels" --command -- sleep 1d 2>/dev/null
done

echo "[SETUP] Environment ready!"
echo "[INFO] Created 16 pods with various type labels"
