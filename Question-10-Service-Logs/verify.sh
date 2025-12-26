#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Pod..."
POD=$(kubectl -n pluto get pod project-plt-6cc-api -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$POD" == "project-plt-6cc-api" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Pod exists"
    
    LABEL=$(kubectl -n pluto get pod project-plt-6cc-api -o jsonpath='{.metadata.labels.project}')
    if [ "$LABEL" == "plt-6cc-api" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Label project=plt-6cc-api"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong label: $LABEL"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} Pod does not exist"
    PASS=false
fi

echo ""
echo "Checking Service..."
SVC=$(kubectl -n pluto get svc project-plt-6cc-svc -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$SVC" == "project-plt-6cc-svc" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Service exists"
    
    PORT=$(kubectl -n pluto get svc project-plt-6cc-svc -o jsonpath='{.spec.ports[0].port}')
    TARGET=$(kubectl -n pluto get svc project-plt-6cc-svc -o jsonpath='{.spec.ports[0].targetPort}')
    if [ "$PORT" == "3333" ] && [ "$TARGET" == "80" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Port mapping 3333:80"
    else
        echo -e "${RED}✗ FAIL:${NC} Port mapping: $PORT:$TARGET (expected 3333:80)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} Service does not exist"
    PASS=false
fi

echo ""
echo "Checking output files..."
if [ -f /opt/course/10/service_test.html ]; then
    echo -e "${GREEN}✓ PASS:${NC} service_test.html exists"
else
    echo -e "${RED}✗ FAIL:${NC} service_test.html does not exist"
    PASS=false
fi

if [ -f /opt/course/10/service_test.log ]; then
    echo -e "${GREEN}✓ PASS:${NC} service_test.log exists"
else
    echo -e "${RED}✗ FAIL:${NC} service_test.log does not exist"
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
