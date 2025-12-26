#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Deployment yaml file..."
if [ ! -f /opt/course/9/holy-api-deployment.yaml ]; then
    echo -e "${RED}✗ FAIL:${NC} File /opt/course/9/holy-api-deployment.yaml does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Deployment yaml file exists"
fi

echo ""
echo "Checking Deployment holy-api..."
DEPLOY=$(kubectl -n pluto get deployment holy-api -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$DEPLOY" != "holy-api" ]; then
    echo -e "${RED}✗ FAIL:${NC} Deployment holy-api does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Deployment holy-api exists"
    
    # Check replicas
    REPLICAS=$(kubectl -n pluto get deployment holy-api -o jsonpath='{.spec.replicas}')
    if [ "$REPLICAS" == "3" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Replicas: $REPLICAS"
    else
        echo -e "${RED}✗ FAIL:${NC} Replicas: $REPLICAS (expected 3)"
        PASS=false
    fi
    
    # Check security context
    ALLOW_PRIV=$(kubectl -n pluto get deployment holy-api -o jsonpath='{.spec.template.spec.containers[0].securityContext.allowPrivilegeEscalation}')
    PRIVILEGED=$(kubectl -n pluto get deployment holy-api -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}')
    
    if [ "$ALLOW_PRIV" == "false" ]; then
        echo -e "${GREEN}✓ PASS:${NC} allowPrivilegeEscalation: false"
    else
        echo -e "${RED}✗ FAIL:${NC} allowPrivilegeEscalation not set to false"
        PASS=false
    fi
    
    if [ "$PRIVILEGED" == "false" ]; then
        echo -e "${GREEN}✓ PASS:${NC} privileged: false"
    else
        echo -e "${RED}✗ FAIL:${NC} privileged not set to false"
        PASS=false
    fi
fi

echo ""
echo "Checking original Pod is deleted..."
POD=$(kubectl -n pluto get pod holy-api --no-headers 2>/dev/null | grep -v "holy-api-" | wc -l)
if [ "$POD" == "0" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Original Pod holy-api deleted"
else
    echo -e "${RED}✗ FAIL:${NC} Original Pod holy-api still exists"
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
