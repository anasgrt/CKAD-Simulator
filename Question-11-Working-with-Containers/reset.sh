#!/bin/bash
echo "[RESET] Cleaning up Question 11..."
if command -v podman &> /dev/null; then
    sudo podman stop sun-cipher 2>/dev/null || true
    sudo podman rm sun-cipher 2>/dev/null || true
fi
rm -f /opt/course/11/logs
# Reset Dockerfile
sed -i 's/SUN_CIPHER_ID=5b9c1065-e39d-4a43-a04a-e59bcea3e03f/SUN_CIPHER_ID=changeme/' /opt/course/11/image/Dockerfile 2>/dev/null || true
echo "[RESET] Done!"
