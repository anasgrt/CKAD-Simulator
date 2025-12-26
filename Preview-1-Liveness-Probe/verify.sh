#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking yaml file..."
if [ -f /opt/course/p1/project-23-api-new.yaml ]; then
    echo -e "${GREEN}✓ PASS:${NC} New yaml file exists"
else
    echo -e "${RED}✗ FAIL:${NC} New yaml file not found"
    PASS=false
fi

echo ""
echo "Checking liveness probe..."
PROBE=$(kubectl -n pluto get deployment project-23-api -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.tcpSocket.port}' 2>/dev/null)
if [ "$PROBE" == "80" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Liveness probe on port 80"
else
    echo -e "${RED}✗ FAIL:${NC} Liveness probe port: $PROBE (expected 80)"
    PASS=false
fi

INITIAL=$(kubectl -n pluto get deployment project-23-api -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.initialDelaySeconds}')
if [ "$INITIAL" == "10" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Initial delay: $INITIAL"
else
    echo -e "${RED}✗ FAIL:${NC} Initial delay: $INITIAL (expected 10)"
    PASS=false
fi

PERIOD=$(kubectl -n pluto get deployment project-23-api -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.periodSeconds}')
if [ "$PERIOD" == "15" ]; then
    echo -e "${GREEN}✓ PASS:${NC} Period: $PERIOD"
else
    echo -e "${RED}✗ FAIL:${NC} Period: $PERIOD (expected 15)"
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
