#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Service endpoints..."
ENDPOINTS=$(kubectl -n mars get endpoints manager-api-svc -o jsonpath='{.subsets[0].addresses}' 2>/dev/null)
if [ -n "$ENDPOINTS" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Service has endpoints"
else
    echo -e "${RED}✗ FAIL:${NC} Service has no endpoints"
    PASS=false
fi

echo ""
echo "Testing connectivity..."
RESULT=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s -m 3 http://manager-api-svc.mars:4444 2>/dev/null | head -1)
if [[ "$RESULT" == *"DOCTYPE"* ]] || [[ "$RESULT" == *"html"* ]] || [[ "$RESULT" == *"Welcome"* ]]; then
    echo -e "${GREEN}✓ PASS:${NC} Service is working"
else
    echo -e "${RED}✗ FAIL:${NC} Cannot connect to service"
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
