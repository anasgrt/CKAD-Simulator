#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PASS=true

echo "Checking Job yaml file..."
if [ ! -f /opt/course/3/job.yaml ]; then
    echo -e "${RED}✗ FAIL:${NC} File /opt/course/3/job.yaml does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Job yaml file exists"
fi

echo ""
echo "Checking Job neb-new-job..."
JOB_EXISTS=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.metadata.name}' 2>/dev/null)
if [ "$JOB_EXISTS" != "neb-new-job" ]; then
    echo -e "${RED}✗ FAIL:${NC} Job neb-new-job does not exist"
    PASS=false
else
    echo -e "${GREEN}✓ PASS:${NC} Job neb-new-job exists"
    
    # Check completions
    COMPLETIONS=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.completions}')
    if [ "$COMPLETIONS" == "3" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Completions: $COMPLETIONS"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong completions: $COMPLETIONS (expected 3)"
        PASS=false
    fi
    
    # Check parallelism
    PARALLELISM=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.parallelism}')
    if [ "$PARALLELISM" == "2" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Parallelism: $PARALLELISM"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong parallelism: $PARALLELISM (expected 2)"
        PASS=false
    fi
    
    # Check pod label
    POD_LABEL=$(kubectl get job neb-new-job -n neptune -o jsonpath='{.spec.template.metadata.labels.id}')
    if [ "$POD_LABEL" == "awesome-job" ]; then
        echo -e "${GREEN}✓ PASS:${NC} Pod label id: $POD_LABEL"
    else
        echo -e "${RED}✗ FAIL:${NC} Wrong pod label: $POD_LABEL (expected awesome-job)"
        PASS=false
    fi
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
