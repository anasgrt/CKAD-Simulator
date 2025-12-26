#!/bin/bash
# Solution for Question 4 - Helm Management

echo "# Step 1: List releases"
helm -n mercury ls

echo ""
echo "# Step 2: Delete internal-issue-report-apiv1"
helm -n mercury uninstall internal-issue-report-apiv1

echo ""
echo "# Step 3: Upgrade internal-issue-report-apiv2"
helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx

echo ""
echo "# Step 4: Show available values for apache chart"
echo "helm show values bitnami/apache | grep replicaCount"

echo ""
echo "# Step 5: Install apache with 2 replicas"
helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2

echo ""
echo "# Step 6: Find broken releases (pending-install)"
echo "helm -n mercury ls -a"
helm -n mercury ls -a

echo ""
echo "# Final state:"
helm -n mercury ls
