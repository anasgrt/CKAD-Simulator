#!/bin/bash
# Solution for Question 19 - ClusterIP to NodePort

echo "# Step 1: Edit the service"
kubectl -n jupiter patch svc jupiter-crew-svc -p '{"spec":{"type":"NodePort","ports":[{"port":8080,"targetPort":80,"nodePort":30100}]}}'

echo ""
echo "# Or use kubectl edit:"
echo "# kubectl -n jupiter edit svc jupiter-crew-svc"
echo "# Change type: ClusterIP to type: NodePort"
echo "# Add nodePort: 30100"

echo ""
echo "# Verify:"
kubectl -n jupiter get svc jupiter-crew-svc

echo ""
echo "# Test with node IP:"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node IP: $NODE_IP"
curl -s http://$NODE_IP:30100 | head -3
