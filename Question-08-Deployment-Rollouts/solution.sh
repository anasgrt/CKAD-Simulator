#!/bin/bash
# Solution for Question 8 - Deployment, Rollouts

echo "# Step 1: Check rollout history"
kubectl -n neptune rollout history deploy api-new-c32

echo ""
echo "# Step 2: Check current pods"
kubectl -n neptune get pod | grep api-new-c32

echo ""
echo "# Step 3: Describe a broken pod to find error"
BROKEN_POD=$(kubectl -n neptune get pod | grep api-new-c32 | grep -v Running | head -1 | awk '{print $1}')
if [ -n "$BROKEN_POD" ]; then
    kubectl -n neptune describe pod $BROKEN_POD | grep -A 5 "Events:"
fi

echo ""
echo "# ERROR FOUND: Image name typo - 'ngnix' instead of 'nginx'"

echo ""
echo "# Step 4: Rollback to previous revision"
kubectl -n neptune rollout undo deploy api-new-c32

echo ""
echo "# Step 5: Verify"
sleep 5
kubectl -n neptune get deploy api-new-c32
kubectl -n neptune get pod | grep api-new-c32
