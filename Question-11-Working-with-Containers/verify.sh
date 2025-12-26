#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
PASS=true

echo "Checking Dockerfile..."
if grep -q "5b9c1065-e39d-4a43-a04a-e59bcea3e03f" /opt/course/11/image/Dockerfile; then
    echo -e "${GREEN}✓ PASS:${NC} Dockerfile has correct SUN_CIPHER_ID"
else
    echo -e "${RED}✗ FAIL:${NC} Dockerfile missing correct SUN_CIPHER_ID"
    PASS=false
fi

echo ""
echo "Checking container (if podman available)..."
if command -v podman &> /dev/null; then
    if podman ps | grep -q sun-cipher; then
        echo -e "${GREEN}✓ PASS:${NC} Container sun-cipher is running"
    else
        echo -e "${RED}✗ FAIL:${NC} Container sun-cipher not running"
        PASS=false
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} Podman not available"
fi

echo ""
echo "Checking logs file..."
if [ -f /opt/course/11/logs ]; then
    echo -e "${GREEN}✓ PASS:${NC} Logs file exists"
    head -3 /opt/course/11/logs
else
    echo -e "${RED}✗ FAIL:${NC} Logs file does not exist"
    PASS=false
fi

echo ""
if [ "$PASS" = true ]; then
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}  ALL CHECKS PASSED!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
else
    echo -e "${RED}═══════════════════════════════════════${NC}"
    echo -e "${RED}  SOME CHECKS FAILED${NC}"
    echo -e "${RED}═══════════════════════════════════════${NC}"
fi
