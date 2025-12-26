#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking InitContainer..."
INIT=$(kubectl -n mars get deployment test-init-container -o jsonpath='{.spec.template.spec.initContainers[0].name}' 2>/dev/null)
if [ "$INIT" == "init-con" ]; then
    echo -e "${GREEN}✓ PASS:${NC} InitContainer init-con exists"
else
    echo -e "${RED}✗ FAIL:${NC} InitContainer init-con not found"
    PASS=false
fi

echo ""
echo "Checking content..."
POD=$(kubectl -n mars get pod -l id=test-init-container -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "$POD" ]; then
    CONTENT=$(kubectl -n mars exec $POD -- cat /usr/share/nginx/html/index.html 2>/dev/null)
    if [[ "$CONTENT" == *"check this out"* ]]; then
        echo -e "${GREEN}✓ PASS:${NC} Content is correct"
    else
        echo -e "${RED}✗ FAIL:${NC} Content not correct: $CONTENT"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} No pod found"
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
