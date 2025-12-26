#!/bin/bash
# Solution for Question 10 - Service, Logs

echo "# Step 1: Create Pod with label"
kubectl -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api

echo ""
echo "# Step 2: Expose Pod as Service"
kubectl -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80

echo ""
echo "# Step 3: Test with curl and save response"
sleep 3
kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s http://project-plt-6cc-svc.pluto:3333 > /opt/course/10/service_test.html

echo ""
echo "# Step 4: Get logs"
kubectl -n pluto logs project-plt-6cc-api > /opt/course/10/service_test.log

echo ""
echo "# Verify files:"
echo "service_test.html:"
head -5 /opt/course/10/service_test.html
echo ""
echo "service_test.log:"
cat /opt/course/10/service_test.log
