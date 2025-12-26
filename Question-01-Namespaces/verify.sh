#!/bin/bash
# Question 1 Verification - Namespaces

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=true

echo "Checking /opt/course/1/namespaces..."

if [ ! -f /opt/course/1/namespaces ]; then
    echo -e "${RED}✗ FAIL:${NC} File /opt/course/1/namespaces does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} File exists"
    
    # Check if it contains namespace names
    if grep -q "default" /opt/course/1/namespaces && grep -q "kube-system" /opt/course/1/namespaces; then
        echo -e "${GREEN}✓ PASS:${NC} File contains expected namespaces"
    else
        echo -e "${RED}✗ FAIL:${NC} File does not contain expected namespace content"
        PASS=false
    fi
    
    # Show content
    echo ""
    echo "File content:"
    cat /opt/course/1/namespaces
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
