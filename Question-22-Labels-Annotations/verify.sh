#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking pods with protected=true label..."
PROTECTED=$(kubectl -n sun get pod -l protected=true --no-headers 2>/dev/null | wc -l)
EXPECTED=12  # All worker and runner pods

if [ "$PROTECTED" -ge 10 ]; then
    echo -e "${GREEN}✓ PASS:${NC} $PROTECTED pods have protected=true label"
else
    echo -e "${RED}✗ FAIL:${NC} Only $PROTECTED pods have protected=true (expected ~$EXPECTED)"
    PASS=false
fi

echo ""
echo "Checking annotations..."
ANNOTATED=$(kubectl -n sun get pod -l protected=true -o jsonpath='{.items[*].metadata.annotations.protected}' 2>/dev/null | grep -o "do not delete" | wc -l)
if [ "$ANNOTATED" -ge 10 ]; then
    echo -e "${GREEN}✓ PASS:${NC} $ANNOTATED pods have correct annotation"
else
    echo -e "${RED}✗ FAIL:${NC} Only $ANNOTATED pods have annotation"
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
