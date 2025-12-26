#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Pod pod1..."
POD_EXISTS=$(kubectl get pod pod1 -n default -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$POD_EXISTS" != "pod1" ]; then
    echo -e "${RED}✗ FAIL:${NC} Pod pod1 does not exist in default namespace"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Pod pod1 exists"
    
    # Check image
    IMAGE=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].image}')
    if [ "$IMAGE" == "httpd:2.4.41-alpine" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Correct image: $IMAGE"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong image: $IMAGE (expected httpd:2.4.41-alpine)"
        PASS=false
    fi
    
    # Check container name
    CONTAINER=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].name}')
    if [ "$CONTAINER" == "pod1-container" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Correct container name: $CONTAINER"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong container name: $CONTAINER (expected pod1-container)"
        PASS=false
    fi
fi

echo ""
echo "Checking status command file..."
if [ ! -f /opt/course/2/pod1-status-command.sh ]; then
    echo -e "${RED}✗ FAIL:${NC} File /opt/course/2/pod1-status-command.sh does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Status command file exists"
    echo "Content:"
    cat /opt/course/2/pod1-status-command.sh
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
