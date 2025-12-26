#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking ConfigMap..."
CM=$(kubectl -n moon get configmap configmap-web-moon-html -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$CM" == "configmap-web-moon-html" ]; then
    echo -e "${GREEN}✓ PASS:${NC} ConfigMap exists"
    
    KEY=$(kubectl -n moon get configmap configmap-web-moon-html -o jsonpath='{.data.index\.html}' | head -1)
    if [ -n "$KEY" ]; then
        echo -e "${GREEN}✓ PASS:${NC} ConfigMap has index.html key"
    else
        echo -e "${RED}✗ FAIL:${NC} ConfigMap missing index.html key"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} ConfigMap does not exist"
    PASS=false
fi

echo ""
echo "Checking Deployment pods are running..."
READY=$(kubectl -n moon get deployment web-moon -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$READY" -gt 0 ] 2>/dev/null; then
    echo -e "${GREEN}✓ PASS:${NC} Pods are running ($READY ready)"
else
    echo -e "${RED}✗ FAIL:${NC} No pods ready"
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
