#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking yaml file..."
if [ -f /opt/course/16/cleaner-new.yaml ]; then
    echo -e "${GREEN}✓ PASS:${NC} cleaner-new.yaml exists"
else
    echo -e "${RED}✗ FAIL:${NC} cleaner-new.yaml does not exist"
    PASS=false
fi

echo ""
echo "Checking sidecar container..."
SIDECAR=$(kubectl -n mercury get deployment cleaner -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="logger-con")].name}' 2>/dev/null)
if [ "$SIDECAR" == "logger-con" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Sidecar container logger-con exists"
else
    echo -e "${RED}✗ FAIL:${NC} Sidecar container logger-con not found"
    PASS=false
fi

echo ""
echo "Checking logs..."
POD=$(kubectl -n mercury get pod -l id=cleaner -o jsonpath='{.items[0].metadata.name}')
LOGS=$(kubectl -n mercury logs $POD -c logger-con 2>/dev/null | head -3)
if [ -n "$LOGS" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Sidecar logs available"
    echo "$LOGS"
else
    echo -e "${RED}✗ FAIL:${NC} No logs from sidecar"
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
