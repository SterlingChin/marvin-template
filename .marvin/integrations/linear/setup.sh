#!/bin/bash
# Linear MCP Setup Script
# Connect MARVIN to Linear for issue tracking and project management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Linear MCP Setup${NC}"
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

# Scope selection
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
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Authentication Method${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "How would you like to authenticate with Linear?"
echo ""
echo "  1) OAuth — browser login, no key needed (recommended)"
echo "  2) API key — paste a personal API key"
echo ""
echo -e "${YELLOW}Choice [1]:${NC}"
read -r AUTH_CHOICE
AUTH_CHOICE=${AUTH_CHOICE:-1}

# Remove existing if present
claude mcp remove linear 2>/dev/null || true

if [[ "$AUTH_CHOICE" == "2" ]]; then
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  API Key Setup${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "To create an API key:"
    echo "  1. Open Linear → Settings → Account → Security & Access → API Keys"
    echo "  2. Click 'Create Key'"
    echo "  3. Copy the key (starts with lin_api_)"
    echo ""
    echo -e "${YELLOW}Paste your Linear API key:${NC}"
    read -rs LINEAR_API_KEY
    echo ""

    # Validate key format
    if [[ ! "$LINEAR_API_KEY" =~ ^lin_api_ ]]; then
        echo -e "${RED}✗ Key should start with 'lin_api_'${NC}"
        echo "Make sure you're copying the full API key from Linear."
        exit 1
    fi

    echo -e "${GREEN}✓ Key format looks good${NC}"

    # Save to .env
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ENV_FILE="$(cd "$SCRIPT_DIR/../../.." && pwd)/.env"

    if [[ -f "$ENV_FILE" ]]; then
        # Update existing .env
        if grep -q "^LINEAR_API_KEY=" "$ENV_FILE"; then
            sed -i.bak "s|^LINEAR_API_KEY=.*|LINEAR_API_KEY=$LINEAR_API_KEY|" "$ENV_FILE"
            rm -f "$ENV_FILE.bak"
        else
            echo "LINEAR_API_KEY=$LINEAR_API_KEY" >> "$ENV_FILE"
        fi
    else
        echo "LINEAR_API_KEY=$LINEAR_API_KEY" > "$ENV_FILE"
    fi
    echo -e "${GREEN}✓ API key saved to .env${NC}"

    echo ""
    echo -e "${BLUE}Adding Linear MCP to Claude Code (API key auth)...${NC}"

    # Add with API key header using streamable HTTP transport
    claude mcp add linear $SCOPE_FLAG \
        --transport http \
        --header "Authorization: Bearer ${LINEAR_API_KEY}" \
        https://mcp.linear.app/mcp

    echo -e "${GREEN}✓ Linear MCP added with API key auth${NC}"
else
    echo ""
    echo -e "${BLUE}Adding Linear MCP to Claude Code (OAuth)...${NC}"

    # Add with SSE transport for OAuth flow
    claude mcp add linear $SCOPE_FLAG \
        --transport sse \
        https://mcp.linear.app/sse

    echo -e "${GREEN}✓ Linear MCP added${NC}"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Authentication${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "Now you need to authenticate with Linear."
    echo ""
    echo -e "${YELLOW}Run this command:${NC}"
    echo ""
    echo "    claude mcp"
    echo ""
    echo "Then:"
    echo "  1. Find 'linear' in the list and select it"
    echo "  2. Choose 'Authenticate'"
    echo "  3. Complete the login in your browser"
    echo ""
    read -p "Press Enter once you've authenticated (or 's' to skip)... " AUTH_RESPONSE

    if [[ "$AUTH_RESPONSE" == "s" || "$AUTH_RESPONSE" == "S" ]]; then
        echo ""
        echo -e "${YELLOW}Skipped authentication.${NC}"
        echo "Remember to run 'claude mcp' and authenticate before using Linear."
    fi
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Try these commands with MARVIN:"
echo -e "  ${YELLOW}\"Show me my open Linear issues\"${NC}"
echo -e "  ${YELLOW}\"Create a Linear issue: Fix login bug — priority high\"${NC}"
echo -e "  ${YELLOW}\"What's the status of ENG-47?\"${NC}"
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
