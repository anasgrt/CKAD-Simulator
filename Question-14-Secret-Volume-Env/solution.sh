#!/bin/bash
# Solution for Question 14 - Secret, Secret-Volume, Secret-Env

echo "# Step 1: Create secret1"
kubectl -n moon create secret generic secret1 --from-literal user=test --from-literal pass=pwd

echo ""
echo "# Step 2: Create secret2 from yaml"
kubectl apply -f /opt/course/14/secret2.yaml

echo ""
echo "# Step 3: Create updated Pod yaml"
cat > /opt/course/14/secret-handler-new.yaml << 'YAML'
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
  - name: secret2-volume
    secret:
      secretName: secret2
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - name: secret2-volume
      mountPath: /tmp/secret2
    env:
    - name: SECRET_KEY_1
      value: ">8$kH#kj..i8}HImQd{"
    - name: SECRET1_USER
      valueFrom:
        secretKeyRef:
          name: secret1
          key: user
    - name: SECRET1_PASS
      valueFrom:
        secretKeyRef:
          name: secret1
          key: pass
YAML

echo ""
echo "# Step 4: Recreate Pod"
kubectl delete pod secret-handler -n moon --force --grace-period=0
kubectl apply -f /opt/course/14/secret-handler-new.yaml

echo ""
echo "# Verify:"
sleep 3
kubectl -n moon exec secret-handler -- env | grep SECRET1
kubectl -n moon exec secret-handler -- cat /tmp/secret2/key
