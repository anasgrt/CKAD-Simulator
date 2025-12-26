#!/bin/bash
# Solution for Question 3 - Job

echo "# Step 1: Generate Job yaml"
kubectl -n neptune create job neb-new-job --image=busybox:1.31.0 \
    --dry-run=client -oyaml -- sh -c "sleep 2 && echo done" > /opt/course/3/job.yaml

echo ""
echo "# Step 2: Edit yaml to add completions, parallelism, labels, container name"
cat > /opt/course/3/job.yaml << 'YAML'
apiVersion: batch/v1
kind: Job
metadata:
  name: neb-new-job
  namespace: neptune
spec:
  completions: 3
  parallelism: 2
  template:
    metadata:
      labels:
        id: awesome-job
    spec:
      containers:
      - command:
        - sh
        - -c
        - sleep 2 && echo done
        image: busybox:1.31.0
        name: neb-new-job-container
      restartPolicy: Never
YAML

echo ""
echo "# Step 3: Create the Job"
kubectl apply -f /opt/course/3/job.yaml

echo ""
echo "# Step 4: Check Job status"
sleep 5
kubectl -n neptune get job,pod | grep neb-new-job
