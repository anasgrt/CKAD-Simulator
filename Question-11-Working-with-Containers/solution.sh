#!/bin/bash
# Solution for Question 11 - Working with Containers

echo "# Step 1: Update Dockerfile with correct ENV value"
sed -i 's/SUN_CIPHER_ID=changeme/SUN_CIPHER_ID=5b9c1065-e39d-4a43-a04a-e59bcea3e03f/' /opt/course/11/image/Dockerfile

echo ""
echo "# Step 2: Build with docker (if available)"
if command -v docker &> /dev/null; then
    cd /opt/course/11/image
    sudo docker build -t localhost:5000/sun-cipher:v1-docker .
    sudo docker push localhost:5000/sun-cipher:v1-docker 2>/dev/null || echo "Push failed - registry may not be available"
fi

echo ""
echo "# Step 3: Build with podman (if available)"
if command -v podman &> /dev/null; then
    cd /opt/course/11/image
    sudo podman build -t localhost:5000/sun-cipher:v1-podman .
    sudo podman push localhost:5000/sun-cipher:v1-podman 2>/dev/null || echo "Push failed - registry may not be available"
fi

echo ""
echo "# Step 4: Run container with podman"
if command -v podman &> /dev/null; then
    sudo podman run -d --name sun-cipher localhost:5000/sun-cipher:v1-podman
fi

echo ""
echo "# Step 5: Get logs"
sleep 2
if command -v podman &> /dev/null; then
    sudo podman logs sun-cipher > /opt/course/11/logs
    cat /opt/course/11/logs
fi
