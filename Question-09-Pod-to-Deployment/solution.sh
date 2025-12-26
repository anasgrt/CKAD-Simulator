#!/bin/bash
# Solution for Question 9 - Pod to Deployment

echo "# Step 1: Copy pod yaml as starting point"
cp /opt/course/9/holy-api-pod.yaml /opt/course/9/holy-api-deployment.yaml

echo ""
echo "# Step 2: Convert to Deployment with security context"
cat > /opt/course/9/holy-api-deployment.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      id: holy-api
  template:
    metadata:
      labels:
        id: holy-api
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
        securityContext:
          allowPrivilegeEscalation: false
          privileged: false
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

echo ""
echo "# Step 3: Create the Deployment"
kubectl apply -f /opt/course/9/holy-api-deployment.yaml

echo ""
echo "# Step 4: Delete the original Pod"
kubectl -n pluto delete pod holy-api --force --grace-period=0

echo ""
echo "# Verify:"
kubectl -n pluto get pod,deployment | grep holy
