#!/bin/bash
# Solution for Question 2 - Pods

echo "# Step 1: Generate Pod yaml with dry-run"
echo "kubectl run pod1 --image=httpd:2.4.41-alpine --dry-run=client -oyaml > 2.yaml"

kubectl run pod1 --image=httpd:2.4.41-alpine --dry-run=client -oyaml > /tmp/2.yaml

echo ""
echo "# Step 2: Edit yaml to change container name to pod1-container"
sed -i 's/name: pod1$/name: pod1-container/' /tmp/2.yaml

echo ""
echo "# Step 3: Create the pod"
kubectl apply -f /tmp/2.yaml

echo ""
echo "# Step 4: Create the status command file"
cat > /opt/course/2/pod1-status-command.sh << 'SCRIPT'
kubectl -n default get pod pod1 -o jsonpath="{.status.phase}"
SCRIPT

echo ""
echo "# Alternative status command:"
echo 'kubectl -n default describe pod pod1 | grep -i status:'

echo ""
echo "# Test the command:"
sh /opt/course/2/pod1-status-command.sh
