#!/bin/bash
# Atlassian MCP Setup Script
# For Postman team members using Claude Code
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
echo -e "${BLUE}  Atlassian MCP Setup (Jira/Confluence)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check Claude Code
if command -v claude &> /dev/null; then
    echo -e "${GREEN}Claude Code installed${NC}"
else
    echo -e "${RED}Claude Code not found${NC}"
    echo "Install with: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo ""
echo -e "${BLUE}Adding Atlassian MCP to Claude Code...${NC}"

# Remove existing if present
claude mcp remove atlassian 2>/dev/null || true

# Add Atlassian remote MCP server
claude mcp add atlassian -s user --transport http https://mcp.atlassian.com/v1/mcp

echo ""
echo -e "${GREEN}Atlassian MCP added!${NC}"

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
echo "  2. The first time you use Jira or Confluence,"
echo "     a browser window will open for authentication."
echo ""
echo "  3. Log in with your Atlassian account"
echo ""
echo "  4. Try it out:"
echo -e "     ${YELLOW}\"Show me my open Jira tickets\"${NC}"
echo -e "     ${YELLOW}\"Search Confluence for API documentation\"${NC}"
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
