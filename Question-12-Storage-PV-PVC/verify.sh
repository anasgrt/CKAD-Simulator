#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking PV..."
PV=$(kubectl get pv earth-project-earthflower-pv -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$PV" == "earth-project-earthflower-pv" ]; then
    echo -e "${GREEN}✓ PASS:${NC} PV exists"
    
    CAP=$(kubectl get pv earth-project-earthflower-pv -o jsonpath='{.spec.capacity.storage}')
    if [ "$CAP" == "2Gi" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Capacity: $CAP"
    else
        echo -e "${RED}✗ FAIL:${NC} Capacity: $CAP (expected 2Gi)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} PV does not exist"
    PASS=false
fi

echo ""
echo "Checking PVC..."
PVC=$(kubectl -n earth get pvc earth-project-earthflower-pvc -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$PVC" == "earth-project-earthflower-pvc" ]; then
    echo -e "${GREEN}✓ PASS:${NC} PVC exists"
    
    STATUS=$(kubectl -n earth get pvc earth-project-earthflower-pvc -o jsonpath='{.status.phase}')
    if [ "$STATUS" == "Bound" ]; then
        echo -e "${GREEN}✓ PASS:${NC} PVC is Bound"
    else
        echo -e "${RED}✗ FAIL:${NC} PVC status: $STATUS (expected Bound)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} PVC does not exist"
    PASS=false
fi

echo ""
echo "Checking Deployment..."
DEPLOY=$(kubectl -n earth get deployment project-earthflower -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$DEPLOY" == "project-earthflower" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Deployment exists"
    
    MOUNT=$(kubectl -n earth get deployment project-earthflower -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].mountPath}')
    if [ "$MOUNT" == "/tmp/project-data" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Mount path: $MOUNT"
    else
        echo -e "${RED}✗ FAIL:${NC} Mount path: $MOUNT (expected /tmp/project-data)"
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
