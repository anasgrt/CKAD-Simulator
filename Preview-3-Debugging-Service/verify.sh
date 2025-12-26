#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking earth-3cc-web pods..."
READY=$(kubectl -n earth get deployment earth-3cc-web -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$READY" -gt 0 ] 2>/dev/null; then
    echo -e "${GREEN}✓ PASS:${NC} Pods are ready ($READY)"
else
    echo -e "${RED}✗ FAIL:${NC} No ready pods"
    PASS=false
fi

echo ""
echo "Checking service connectivity..."
RESULT=$(kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -s -m 3 http://earth-3cc-web.earth:6363 2>/dev/null | head -1)
if [[ "$RESULT" == *"html"* ]] || [[ "$RESULT" == *"DOCTYPE"* ]]; then
    echo -e "${GREEN}✓ PASS:${NC} Service is accessible"
else
    echo -e "${RED}✗ FAIL:${NC} Cannot connect to service"
    PASS=false
fi

echo ""
echo "Checking ticket file..."
if [ -f /opt/course/p3/ticket-654.txt ]; then
    echo -e "${GREEN}✓ PASS:${NC} Ticket file exists"
    cat /opt/course/p3/ticket-654.txt
else
    echo -e "${RED}✗ FAIL:${NC} Ticket file not found"
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
