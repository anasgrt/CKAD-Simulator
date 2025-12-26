#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Deployment..."
DEPLOY=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$DEPLOY" == "neptune-10ab" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Deployment exists"
    
    # Check replicas
    REPLICAS=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.spec.replicas}')
    if [ "$REPLICAS" == "3" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Replicas: $REPLICAS"
    else
        echo -e "${RED}✗ FAIL:${NC} Replicas: $REPLICAS (expected 3)"
        PASS=false
    fi
    
    # Check container name
    CONTAINER=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.spec.template.spec.containers[0].name}')
    if [ "$CONTAINER" == "neptune-pod-10ab" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Container name: $CONTAINER"
    else
        echo -e "${RED}✗ FAIL:${NC} Container name: $CONTAINER (expected neptune-pod-10ab)"
        PASS=false
    fi
    
    # Check memory request
    MEM_REQ=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
    if [ "$MEM_REQ" == "20Mi" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Memory request: $MEM_REQ"
    else
        echo -e "${RED}✗ FAIL:${NC} Memory request: $MEM_REQ (expected 20Mi)"
        PASS=false
    fi
    
    # Check memory limit
    MEM_LIM=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')
    if [ "$MEM_LIM" == "50Mi" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Memory limit: $MEM_LIM"
    else
        echo -e "${RED}✗ FAIL:${NC} Memory limit: $MEM_LIM (expected 50Mi)"
        PASS=false
    fi
    
    # Check ServiceAccount
    SA=$(kubectl -n neptune get deployment neptune-10ab -o jsonpath='{.spec.template.spec.serviceAccountName}')
    if [ "$SA" == "neptune-sa-v2" ]; then
        echo -e "${GREEN}✓ PASS:${NC} ServiceAccount: $SA"
    else
        echo -e "${RED}✗ FAIL:${NC} ServiceAccount: $SA (expected neptune-sa-v2)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} Deployment does not exist"
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
