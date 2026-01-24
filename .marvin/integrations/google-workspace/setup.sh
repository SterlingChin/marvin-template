#!/bin/bash
# Google Workspace Setup for Claude Code
# Created by Sterling Chin
#
# This sets up Google Workspace MCP with the correct scopes
# (excludes Tasks API which has a bug)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Google Workspace Setup for Claude${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Shared Client ID
GOOGLE_CLIENT_ID="1040834205770-pm3p706jo090otse75td7ob9bdfrbomq.apps.googleusercontent.com"

# Get client secret
if [ -z "$GOOGLE_OAUTH_CLIENT_SECRET" ]; then
    echo -e "${YELLOW}Enter the Google OAuth Client Secret${NC}"
    echo "(Ask Sterling if you don't have it)"
    echo ""
    read -s -p "Client Secret: " GOOGLE_CLIENT_SECRET
    echo ""
else
    GOOGLE_CLIENT_SECRET="$GOOGLE_OAUTH_CLIENT_SECRET"
fi

if [ -z "$GOOGLE_CLIENT_SECRET" ]; then
    echo -e "${RED}Error: Client secret is required${NC}"
    exit 1
fi

# Check prerequisites
echo ""
echo -e "${BLUE}Checking prerequisites...${NC}"

if command -v uvx &> /dev/null; then
    echo -e "${GREEN}  uv/uvx installed${NC}"
else
    echo -e "${YELLOW}  Installing uv...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if command -v claude &> /dev/null; then
    echo -e "${GREEN}  Claude Code installed${NC}"
else
    echo -e "${RED}  Claude Code not found${NC}"
    echo "  Install: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Remove existing MCP if present
echo ""
echo -e "${BLUE}Configuring Google Workspace MCP...${NC}"
claude mcp remove google-workspace 2>/dev/null || true

# Add MCP with specific tools (excludes tasks which has scope bug)
claude mcp add google-workspace -s user \
    --env GOOGLE_OAUTH_CLIENT_ID="$GOOGLE_CLIENT_ID" \
    --env GOOGLE_OAUTH_CLIENT_SECRET="$GOOGLE_CLIENT_SECRET" \
    -- uvx workspace-mcp --tools gmail drive calendar docs sheets slides

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Start Claude Code: ${YELLOW}claude${NC}"
echo ""
echo "  2. First Google request will open browser for login"
echo ""
echo "  3. Try: ${YELLOW}\"What's on my calendar today?\"${NC}"
echo ""
