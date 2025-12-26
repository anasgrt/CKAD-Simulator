#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Secret secret1..."
SECRET1=$(kubectl -n moon get secret secret1 -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$SECRET1" == "secret1" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Secret secret1 exists"
else
    echo -e "${RED}✗ FAIL:${NC} Secret secret1 does not exist"
    PASS=false
fi

echo ""
echo "Checking Secret secret2..."
SECRET2=$(kubectl -n moon get secret secret2 -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$SECRET2" == "secret2" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Secret secret2 exists"
else
    echo -e "${RED}✗ FAIL:${NC} Secret secret2 does not exist"
    PASS=false
fi

echo ""
echo "Checking Pod environment variables..."
SECRET1_USER=$(kubectl -n moon exec secret-handler -- env 2>/dev/null | grep SECRET1_USER | cut -d= -f2)
if [ "$SECRET1_USER" == "test" ]; then
    echo -e "${GREEN}✓ PASS:${NC} SECRET1_USER=test"
else
    echo -e "${RED}✗ FAIL:${NC} SECRET1_USER not set correctly"
    PASS=false
fi

echo ""
echo "Checking volume mount..."
MOUNT=$(kubectl -n moon exec secret-handler -- ls /tmp/secret2 2>/dev/null)
if [ -n "$MOUNT" ]; then
    echo -e "${GREEN}✓ PASS:${NC} /tmp/secret2 mounted"
else
    echo -e "${RED}✗ FAIL:${NC} /tmp/secret2 not mounted"
    PASS=false
fi

echo ""
echo "Checking yaml file..."
if [ -f /opt/course/14/secret-handler-new.yaml ]; then
    echo -e "${GREEN}✓ PASS:${NC} secret-handler-new.yaml exists"
else
    echo -e "${RED}✗ FAIL:${NC} secret-handler-new.yaml does not exist"
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
