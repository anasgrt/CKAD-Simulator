#!/bin/bash
# Question 1 Solution - Namespaces

echo "# Solution for Question 1 - Namespaces"
echo ""
echo "# Simply get all namespaces and redirect to file:"
echo "kubectl get ns > /opt/course/1/namespaces"
echo ""

# Execute solution
kubectl get ns > /opt/course/1/namespaces

echo "# Verification:"
cat /opt/course/1/namespaces
