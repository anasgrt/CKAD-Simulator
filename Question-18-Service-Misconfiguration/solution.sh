#!/bin/bash
# Solution for Question 18 - Service Misconfiguration

echo "# Step 1: Check endpoints"
kubectl -n mars get endpoints manager-api-svc

echo ""
echo "# Step 2: Check pod labels"
kubectl -n mars get pod --show-labels

echo ""
echo "# Step 3: Check service selector"
kubectl -n mars get svc manager-api-svc -o yaml | grep -A 2 selector

echo ""
echo "# Problem: selector is 'id: manager-api-deployment' but pods have 'id: manager-api-pod'"

echo ""
echo "# Step 4: Fix the selector"
kubectl -n mars patch svc manager-api-svc -p '{"spec":{"selector":{"id":"manager-api-pod"}}}'

echo ""
echo "# Verify:"
kubectl -n mars get endpoints manager-api-svc
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s http://manager-api-svc.mars:4444 | head -5
