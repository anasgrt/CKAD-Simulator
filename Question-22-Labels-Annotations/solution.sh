#!/bin/bash
# Solution for Question 22 - Labels, Annotations

echo "# Step 1: Show current pods with labels"
kubectl -n sun get pod --show-labels

echo ""
echo "# Step 2: Add label to worker and runner pods"
kubectl -n sun label pod -l "type in (worker,runner)" protected=true

echo ""
echo "# Step 3: Add annotation to protected pods"
kubectl -n sun annotate pod -l protected=true protected="do not delete this pod"

echo ""
echo "# Verify:"
kubectl -n sun get pod -l protected=true --show-labels
