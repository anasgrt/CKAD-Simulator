#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Deployment api-new-c32..."
READY=$(kubectl -n neptune get deployment api-new-c32 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
DESIRED=$(kubectl -n neptune get deployment api-new-c32 -o jsonpath='{.spec.replicas}' 2>/dev/null)

if [ "$READY" == "$DESIRED" ] && [ "$READY" -gt 0 ]; then
    echo -e "${GREEN}✓ PASS:${NC} All replicas are ready ($READY/$DESIRED)"
else
    echo -e "${RED}✗ FAIL:${NC} Not all replicas ready ($READY/$DESIRED)"
    PASS=false
fi

# Check image is not the broken one
IMAGE=$(kubectl -n neptune get deployment api-new-c32 -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$IMAGE" == *"ngnix"* ]]; then
    echo -e "${RED}✗ FAIL:${NC} Still using broken image: $IMAGE"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Using working image: $IMAGE"
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
