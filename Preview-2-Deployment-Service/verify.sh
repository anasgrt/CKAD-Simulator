#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Deployment..."
DEPLOY=$(kubectl -n sun get deployment sunny -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$DEPLOY" == "sunny" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Deployment exists"
    
    REPLICAS=$(kubectl -n sun get deployment sunny -o jsonpath='{.spec.replicas}')
    if [ "$REPLICAS" == "4" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Replicas: $REPLICAS"
    else
        echo -e "${RED}✗ FAIL:${NC} Replicas: $REPLICAS (expected 4)"
        PASS=false
    fi
    
    SA=$(kubectl -n sun get deployment sunny -o jsonpath='{.spec.template.spec.serviceAccountName}')
    if [ "$SA" == "sa-sun-deploy" ]; then
        echo -e "${GREEN}✓ PASS:${NC} ServiceAccount: $SA"
    else
        echo -e "${RED}✗ FAIL:${NC} ServiceAccount: $SA (expected sa-sun-deploy)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} Deployment does not exist"
    PASS=false
fi

echo ""
echo "Checking Service..."
SVC=$(kubectl -n sun get svc sun-srv -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$SVC" == "sun-srv" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Service exists"
    
    PORT=$(kubectl -n sun get svc sun-srv -o jsonpath='{.spec.ports[0].port}')
    if [ "$PORT" == "9999" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Port: $PORT"
    else
        echo -e "${RED}✗ FAIL:${NC} Port: $PORT (expected 9999)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} Service does not exist"
    PASS=false
fi

echo ""
echo "Checking status command..."
if [ -f /opt/course/p2/sunny_status_command.sh ]; then
    echo -e "${GREEN}✓ PASS:${NC} Status command file exists"
else
    echo -e "${RED}✗ FAIL:${NC} Status command file not found"
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
