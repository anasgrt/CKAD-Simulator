#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking NetworkPolicy..."
NP=$(kubectl -n venus get networkpolicy np1 -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$NP" == "np1" ]; then
    echo -e "${GREEN}✓ PASS:${NC} NetworkPolicy np1 exists"
else
    echo -e "${RED}✗ FAIL:${NC} NetworkPolicy np1 not found"
    PASS=false
fi

echo ""
echo "Checking policy selects frontend pods..."
SELECTOR=$(kubectl -n venus get networkpolicy np1 -o jsonpath='{.spec.podSelector.matchLabels.id}' 2>/dev/null)
if [ "$SELECTOR" == "frontend" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Policy selects frontend pods"
else
    echo -e "${RED}✗ FAIL:${NC} Policy selector: $SELECTOR (expected frontend)"
    PASS=false
fi

echo ""
echo "Checking egress rules..."
EGRESS=$(kubectl -n venus get networkpolicy np1 -o jsonpath='{.spec.egress}' 2>/dev/null)
if [ -n "$EGRESS" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Egress rules defined"
else
    echo -e "${RED}✗ FAIL:${NC} No egress rules"
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
