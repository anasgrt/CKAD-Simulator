#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking webserver-sat-003 in neptune..."
POD_IN_NEPTUNE=$(kubectl get pod webserver-sat-003 -n neptune -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$POD_IN_NEPTUNE" == "webserver-sat-003" ]; then
    echo -e "${GREEN}✓ PASS:${NC} webserver-sat-003 exists in neptune namespace"
else
    echo -e "${RED}✗ FAIL:${NC} webserver-sat-003 not found in neptune namespace"
    PASS=false
fi

echo ""
echo "Checking webserver-sat-003 NOT in saturn..."
POD_IN_SATURN=$(kubectl get pod webserver-sat-003 -n saturn -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ -z "$POD_IN_SATURN" ]; then
    echo -e "${GREEN}✓ PASS:${NC} webserver-sat-003 removed from saturn namespace"
else
    echo -e "${RED}✗ FAIL:${NC} webserver-sat-003 still exists in saturn namespace"
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
