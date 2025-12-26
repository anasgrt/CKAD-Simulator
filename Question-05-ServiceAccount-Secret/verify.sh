#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking token file..."
if [ ! -f /opt/course/5/token ]; then
    echo -e "${RED}✗ FAIL:${NC} File /opt/course/5/token does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Token file exists"
    
    # Check if it looks like a JWT token
    TOKEN=$(cat /opt/course/5/token)
    if [[ "$TOKEN" == eyJ* ]]; then
        echo -e "${GREEN}✓ PASS:${NC} Token appears to be valid JWT format"
    else
        echo -e "${RED}✗ FAIL:${NC} Token does not appear to be valid (should start with eyJ)"
        PASS=false
    fi
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
