#!/bin/bash
# Solution for Question 6 - ReadinessProbe

echo "# Step 1: Generate base pod yaml"
kubectl run pod6 --image=busybox:1.31.0 --dry-run=client -oyaml \
    --command -- sh -c "touch /tmp/ready && sleep 1d" > /tmp/6.yaml

echo ""
echo "# Step 2: Add readiness probe to yaml"
cat > /tmp/6.yaml << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: pod6
spec:
  containers:
  - command:
    - sh
    - -c
    - touch /tmp/ready && sleep 1d
    image: busybox:1.31.0
    name: pod6
    readinessProbe:
      exec:
        command:
        - sh
        - -c
        - cat /tmp/ready
      initialDelaySeconds: 5
      periodSeconds: 10
YAML

echo ""
echo "# Step 3: Create the pod"
kubectl apply -f /tmp/6.yaml

echo ""
echo "# Step 4: Wait and check status"
sleep 10
kubectl get pod pod6
