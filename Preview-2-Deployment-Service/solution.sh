#!/bin/bash
# Solution for Preview 2 - Deployment and Service

echo "# Step 1: Create Deployment"
cat <<YAML | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sunny
  namespace: sun
spec:
  replicas: 4
  selector:
    matchLabels:
      app: sunny
  template:
    metadata:
      labels:
        app: sunny
    spec:
      serviceAccountName: sa-sun-deploy
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
YAML

echo ""
echo "# Step 2: Expose as Service"
kubectl -n sun expose deployment sunny --name sun-srv --port 9999 --target-port 80

echo ""
echo "# Step 3: Create status command"
cat > /opt/course/p2/sunny_status_command.sh << 'CMD'
kubectl -n sun get deployment sunny
CMD

echo ""
echo "# Test:"
sh /opt/course/p2/sunny_status_command.sh
