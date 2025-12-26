#!/bin/bash
# Solution for Question 17 - InitContainer

echo "# Step 1: Edit yaml to add InitContainer"
cat > /opt/course/17/test-init-container.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      initContainers:
      - name: init-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'echo "check this out!" > /tmp/web-content/index.html']
        volumeMounts:
        - name: web-content
          mountPath: /tmp/web-content
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
YAML

echo ""
echo "# Step 2: Create the Deployment"
kubectl apply -f /opt/course/17/test-init-container.yaml

echo ""
echo "# Step 3: Test"
sleep 5
POD_IP=$(kubectl -n mars get pod -l id=test-init-container -o jsonpath='{.items[0].status.podIP}')
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s http://$POD_IP
