#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

if ! command -v helm &> /dev/null; then
    echo -e "${RED}✗ FAIL:${NC} Helm is not installed"
    exit 1
fi

echo "Checking helm releases in mercury namespace..."
echo ""

# Check apiv1 is deleted
if helm -n mercury list | grep -q "internal-issue-report-apiv1"; then
    echo -e "${RED}✗ FAIL:${NC} internal-issue-report-apiv1 should be deleted"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} internal-issue-report-apiv1 is deleted"
fi

# Check apiv2 is upgraded
if helm -n mercury list | grep -q "internal-issue-report-apiv2"; then
    echo -e "${GREEN}✓ PASS:${NC} internal-issue-report-apiv2 exists"
else
    echo -e "${RED}✗ FAIL:${NC} internal-issue-report-apiv2 not found"
    PASS=false
fi

# Check apache is installed
if helm -n mercury list | grep -q "internal-issue-report-apache"; then
    echo -e "${GREEN}✓ PASS:${NC} internal-issue-report-apache is installed"
    
    # Check replicas
    REPLICAS=$(kubectl -n mercury get deploy -l app.kubernetes.io/instance=internal-issue-report-apache \
        -o jsonpath='{.items[0].spec.replicas}' 2>/dev/null)
    if [ "$REPLICAS" == "2" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Apache has 2 replicas"
    else
        echo -e "${RED}✗ FAIL:${NC} Apache replicas: $REPLICAS (expected 2)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} internal-issue-report-apache not found"
    PASS=false
fi

echo ""
helm -n mercury list

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
