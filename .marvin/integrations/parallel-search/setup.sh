#!/bin/bash
# Parallel Search MCP Setup Script
# Web search integration for Claude Code
# Created by Sterling Chin

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Parallel Search MCP Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check Claude Code
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code installed${NC}"
else
    echo -e "${RED}✗ Claude Code not found${NC}"
    echo "Install with: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo ""
echo "Where should this integration be available?"
echo "  1) All projects (user-scoped)"
echo "  2) This project only (project-scoped)"
echo ""
echo -e "${YELLOW}Choice [1]:${NC}"
read -r SCOPE_CHOICE
SCOPE_CHOICE=${SCOPE_CHOICE:-1}

if [[ "$SCOPE_CHOICE" == "1" ]]; then
    SCOPE_FLAG="-s user"
else
    SCOPE_FLAG=""
fi

echo ""
echo -e "${BLUE}Adding Parallel Search MCP to Claude Code...${NC}"

# Remove existing if present
claude mcp remove parallel-search 2>/dev/null || true

# Add Parallel Search remote MCP server
claude mcp add parallel-search $SCOPE_FLAG --transport http https://search.parallel.ai/mcp

echo ""
echo -e "${GREEN}Parallel Search MCP added!${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Start Claude Code:"
echo -e "     ${YELLOW}claude${NC}"
echo ""
echo "  2. Try it out:"
echo -e "     ${YELLOW}\"Search the web for latest Node.js releases\"${NC}"
echo -e "     ${YELLOW}\"What's the weather in San Francisco?\"${NC}"
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
