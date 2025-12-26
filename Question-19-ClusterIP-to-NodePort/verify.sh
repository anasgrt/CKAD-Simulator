#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Service type..."
TYPE=$(kubectl -n jupiter get svc jupiter-crew-svc -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$TYPE" == "NodePort" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Service is NodePort"
else
    echo -e "${RED}✗ FAIL:${NC} Service type: $TYPE (expected NodePort)"
    PASS=false
fi

echo ""
echo "Checking NodePort..."
NODEPORT=$(kubectl -n jupiter get svc jupiter-crew-svc -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ "$NODEPORT" == "30100" ]; then
    echo -e "${GREEN}✓ PASS:${NC} NodePort: $NODEPORT"
else
    echo -e "${RED}✗ FAIL:${NC} NodePort: $NODEPORT (expected 30100)"
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
