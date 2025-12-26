#!/bin/bash

#===============================================================================
# CKAD Simulator Practice - Question Runner
# Based on killer.sh CKAD Simulator Kubernetes 1.34
#===============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}CKAD Simulator Practice - killer.sh Style${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
}

print_usage() {
    echo -e "${BOLD}Usage:${NC}"
    echo "  $0 <question-folder> [command]"
    echo ""
    echo -e "${BOLD}Commands:${NC}"
    echo "  (none)    - Setup environment and show question"
    echo "  verify    - Verify your answer"
    echo "  solution  - Show the solution"
    echo "  reset     - Reset/cleanup the question environment"
    echo "  list      - List all available questions"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  $0 list"
    echo "  $0 Question-01-Namespaces"
    echo "  $0 Question-01-Namespaces verify"
    echo "  $0 Question-01-Namespaces solution"
    echo "  $0 Question-01-Namespaces reset"
}

list_questions() {
    print_header
    echo ""
    echo -e "${BOLD}Available Questions:${NC}"
    echo ""
    
    # Main Questions
    echo -e "${YELLOW}Main Questions (22):${NC}"
    for dir in "$BASE_DIR"/Question-*/; do
        if [ -d "$dir" ]; then
            name=$(basename "$dir")
            if [ -f "$dir/question.txt" ]; then
                # Extract first line as title
                title=$(head -1 "$dir/question.txt" 2>/dev/null | sed 's/^#\s*//')
                printf "  ${GREEN}%-35s${NC} %s\n" "$name" "$title"
            else
                echo -e "  ${GREEN}$name${NC}"
            fi
        fi
    done
    
    echo ""
    echo -e "${YELLOW}Preview Questions (3):${NC}"
    for dir in "$BASE_DIR"/Preview-*/; do
        if [ -d "$dir" ]; then
            name=$(basename "$dir")
            if [ -f "$dir/question.txt" ]; then
                title=$(head -1 "$dir/question.txt" 2>/dev/null | sed 's/^#\s*//')
                printf "  ${GREEN}%-35s${NC} %s\n" "$name" "$title"
            else
                echo -e "  ${GREEN}$name${NC}"
            fi
        fi
    done
    echo ""
}

run_setup() {
    local question_dir="$1"
    
    print_header
    echo ""
    
    if [ -f "$question_dir/setup.sh" ]; then
        echo -e "${BLUE}[SETUP]${NC} Setting up environment..."
        echo ""
        bash "$question_dir/setup.sh"
        echo ""
    fi
    
    if [ -f "$question_dir/question.txt" ]; then
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}QUESTION${NC}                                                       ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        cat "$question_dir/question.txt"
        echo ""
    fi
    
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  Verify:   ${GREEN}$0 $(basename $question_dir) verify${NC}"
    echo -e "  Solution: ${GREEN}$0 $(basename $question_dir) solution${NC}"
    echo -e "  Reset:    ${GREEN}$0 $(basename $question_dir) reset${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

run_verify() {
    local question_dir="$1"
    
    print_header
    echo ""
    
    if [ -f "$question_dir/verify.sh" ]; then
        echo -e "${BLUE}[VERIFY]${NC} Checking your answer..."
        echo ""
        bash "$question_dir/verify.sh"
    else
        echo -e "${RED}[ERROR]${NC} No verify.sh found for this question"
        exit 1
    fi
}

run_solution() {
    local question_dir="$1"
    
    print_header
    echo ""
    
    if [ -f "$question_dir/solution.sh" ]; then
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${NC}  ${BOLD}SOLUTION${NC}                                                       ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        cat "$question_dir/solution.sh"
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BOLD}Run the solution?${NC} (y/n): "
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo ""
            echo -e "${BLUE}[RUNNING]${NC} Executing solution..."
            bash "$question_dir/solution.sh"
        fi
    else
        echo -e "${RED}[ERROR]${NC} No solution.sh found for this question"
        exit 1
    fi
}

run_reset() {
    local question_dir="$1"
    
    print_header
    echo ""
    
    if [ -f "$question_dir/reset.sh" ]; then
        echo -e "${BLUE}[RESET]${NC} Cleaning up environment..."
        echo ""
        bash "$question_dir/reset.sh"
        echo ""
        echo -e "${GREEN}[DONE]${NC} Environment reset complete"
    else
        echo -e "${RED}[ERROR]${NC} No reset.sh found for this question"
        exit 1
    fi
}

# Main
if [ $# -eq 0 ]; then
    print_header
    echo ""
    print_usage
    exit 0
fi

if [ "$1" == "list" ]; then
    list_questions
    exit 0
fi

QUESTION_NAME="$1"
COMMAND="${2:-setup}"

# Find question directory
QUESTION_DIR=""
for dir in "$BASE_DIR"/Question-*/ "$BASE_DIR"/Preview-*/; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        if [ "$dirname" == "$QUESTION_NAME" ]; then
            QUESTION_DIR="$dir"
            break
        fi
    fi
done

if [ -z "$QUESTION_DIR" ] || [ ! -d "$QUESTION_DIR" ]; then
    echo -e "${RED}[ERROR]${NC} Question '$QUESTION_NAME' not found"
    echo ""
    echo "Use '$0 list' to see available questions"
    exit 1
fi

case "$COMMAND" in
    setup|"")
        run_setup "$QUESTION_DIR"
        ;;
    verify)
        run_verify "$QUESTION_DIR"
        ;;
    solution)
        run_solution "$QUESTION_DIR"
        ;;
    reset)
        run_reset "$QUESTION_DIR"
        ;;
    *)
        echo -e "${RED}[ERROR]${NC} Unknown command: $COMMAND"
        print_usage
        exit 1
        ;;
esac
