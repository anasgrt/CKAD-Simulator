#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Pod pod6..."
POD_EXISTS=$(kubectl get pod pod6 -n default -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$POD_EXISTS" != "pod6" ]; then
    echo -e "${RED}✗ FAIL:${NC} Pod pod6 does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Pod pod6 exists"
    
    # Check readiness probe
    PROBE=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.exec.command}' 2>/dev/null)
    if [[ "$PROBE" == *"cat"* && "$PROBE" == *"/tmp/ready"* ]]; then
        echo -e "${GREEN}✓ PASS:${NC} Readiness probe configured correctly"
    else
        echo -e "${RED}✗ FAIL:${NC} Readiness probe not configured correctly"
        PASS=false
    fi
    
    # Check initial delay
    INITIAL=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.initialDelaySeconds}')
    if [ "$INITIAL" == "5" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Initial delay: $INITIAL seconds"
    else
        echo -e "${RED}✗ FAIL:${NC} Initial delay: $INITIAL (expected 5)"
        PASS=false
    fi
    
    # Check period
    PERIOD=$(kubectl get pod pod6 -o jsonpath='{.spec.containers[0].readinessProbe.periodSeconds}')
    if [ "$PERIOD" == "10" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Period: $PERIOD seconds"
    else
        echo -e "${RED}✗ FAIL:${NC} Period: $PERIOD (expected 10)"
        PASS=false
    fi
    
    # Check if running
    STATUS=$(kubectl get pod pod6 -o jsonpath='{.status.phase}')
    READY=$(kubectl get pod pod6 -o jsonpath='{.status.containerStatuses[0].ready}')
    echo "Pod status: $STATUS, Ready: $READY"
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
