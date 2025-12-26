#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking StorageClass..."
SC=$(kubectl get storageclass moon-retain -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$SC" == "moon-retain" ]; then
    echo -e "${GREEN}✓ PASS:${NC} StorageClass exists"
    
    PROV=$(kubectl get storageclass moon-retain -o jsonpath='{.provisioner}')
    if [ "$PROV" == "moon-retainer" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Provisioner: $PROV"
    else
        echo -e "${RED}✗ FAIL:${NC} Provisioner: $PROV (expected moon-retainer)"
        PASS=false
    fi
    
    RECLAIM=$(kubectl get storageclass moon-retain -o jsonpath='{.reclaimPolicy}')
    if [ "$RECLAIM" == "Retain" ]; then
        echo -e "${GREEN}✓ PASS:${NC} ReclaimPolicy: $RECLAIM"
    else
        echo -e "${RED}✗ FAIL:${NC} ReclaimPolicy: $RECLAIM (expected Retain)"
        PASS=false
    fi
else
    echo -e "${RED}✗ FAIL:${NC} StorageClass does not exist"
    PASS=false
fi

echo ""
echo "Checking PVC..."
PVC=$(kubectl -n moon get pvc moon-pvc-126 -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$PVC" == "moon-pvc-126" ]; then
    echo -e "${GREEN}✓ PASS:${NC} PVC exists"
else
    echo -e "${RED}✗ FAIL:${NC} PVC does not exist"
    PASS=false
fi

echo ""
echo "Checking reason file..."
if [ -f /opt/course/13/pvc-126-reason ]; then
    echo -e "${GREEN}✓ PASS:${NC} Reason file exists"
    cat /opt/course/13/pvc-126-reason
else
    echo -e "${RED}✗ FAIL:${NC} Reason file does not exist"
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
