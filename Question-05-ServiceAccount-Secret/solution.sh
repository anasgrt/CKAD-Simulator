#!/bin/bash
# Solution for Question 5 - ServiceAccount, Secret

echo "# Step 1: List secrets in neptune namespace"
kubectl -n neptune get secrets

echo ""
echo "# Step 2: Find secret with service-account annotation"
kubectl -n neptune get secrets -oyaml | grep "service-account.name" -A 1

echo ""
echo "# Step 3: Describe the secret to get decoded token"
kubectl -n neptune describe secret neptune-secret-1

echo ""
echo "# Step 4: Extract and save the token"
# The describe command shows decoded token, just copy it
kubectl -n neptune describe secret neptune-secret-1 | grep "token:" | awk '{print $2}' > /opt/course/5/token

echo ""
echo "# Token saved to /opt/course/5/token"
head -c 50 /opt/course/5/token
echo "..."
