#!/bin/bash
# Solution for Question 20 - NetworkPolicy

echo "# Create NetworkPolicy"
cat <<YAML | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np1
  namespace: venus
spec:
  podSelector:
    matchLabels:
      id: frontend
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          id: api
  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
YAML

echo ""
echo "# Test from frontend pod:"
POD=$(kubectl -n venus get pod -l id=frontend -o jsonpath='{.items[0].metadata.name}')
echo "Testing api:2222 (should work)..."
kubectl -n venus exec $POD -- wget -O- -T 3 api:2222 2>/dev/null | head -1

echo ""
echo "Testing www.google.com (should timeout)..."
kubectl -n venus exec $POD -- wget -O- -T 3 www.google.com 2>&1 | head -2
