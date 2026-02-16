#!/bin/bash
# Notion MCP Setup Script
# Connect MARVIN to Notion for pages, databases, and notes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Notion MCP Setup${NC}"
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

# Check Node.js (needed for npx-based local server)
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js installed$(node --version 2>/dev/null | sed 's/^/ /')${NC}"
else
    echo -e "${RED}✗ Node.js not found${NC}"
    echo "Node.js is required for the Notion MCP server."
    echo "Install from: https://nodejs.org"
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
echo "How would you like to authenticate with Notion?"
echo ""
echo "  1) API token — internal integration token (recommended)"
echo "  2) OAuth — browser login"
echo ""
echo -e "${YELLOW}Choice [1]:${NC}"
read -r AUTH_CHOICE
AUTH_CHOICE=${AUTH_CHOICE:-1}

# Remove existing if present
claude mcp remove notion 2>/dev/null || true

if [[ "$AUTH_CHOICE" == "2" ]]; then
    echo ""
    echo -e "${BLUE}Adding Notion MCP to Claude Code (OAuth)...${NC}"

    # Add remote OAuth MCP server
    claude mcp add notion $SCOPE_FLAG \
        --transport http \
        https://mcp.notion.com/mcp

    echo -e "${GREEN}✓ Notion MCP added${NC}"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Authentication${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "Now you need to authenticate with Notion."
    echo ""
    echo -e "${YELLOW}Run this command:${NC}"
    echo ""
    echo "    claude mcp"
    echo ""
    echo "Then:"
    echo "  1. Find 'notion' in the list and select it"
    echo "  2. Choose 'Authenticate'"
    echo "  3. Complete the login in your browser"
    echo "  4. Select which pages to grant access to"
    echo ""
    echo -e "${YELLOW}Note: If the OAuth flow fails, re-run this script and choose Option 1 (API token) instead.${NC}"
    echo ""
    read -p "Press Enter once you've authenticated (or 's' to skip)... " AUTH_RESPONSE

    if [[ "$AUTH_RESPONSE" == "s" || "$AUTH_RESPONSE" == "S" ]]; then
        echo ""
        echo -e "${YELLOW}Skipped authentication.${NC}"
        echo "Remember to run 'claude mcp' and authenticate before using Notion."
    fi
else
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Step 1: Create a Notion Integration${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "You need an internal integration token from Notion."
    echo ""
    echo "  1. Go to: https://www.notion.so/profile/integrations"
    echo "  2. Click 'New integration'"
    echo "  3. Name it (e.g., 'MARVIN')"
    echo "  4. Select your workspace"
    echo "  5. Under Capabilities, enable: Read, Update, and Insert content"
    echo "  6. Click 'Submit' and copy the token (starts with ntn_)"
    echo ""
    echo -e "${YELLOW}Paste your Notion integration token:${NC}"
    read -rs NOTION_TOKEN
    echo ""

    # Validate token format
    if [[ ! "$NOTION_TOKEN" =~ ^ntn_ ]]; then
        echo -e "${RED}✗ Token should start with 'ntn_'${NC}"
        echo "Make sure you're copying the Internal Integration Secret."
        exit 1
    fi

    echo -e "${GREEN}✓ Token format looks good${NC}"

    # Save to .env
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ENV_FILE="$(cd "$SCRIPT_DIR/../../.." && pwd)/.env"

    if [[ -f "$ENV_FILE" ]]; then
        # Update existing .env
        if grep -q "^NOTION_TOKEN=" "$ENV_FILE" || grep -q "^NOTION_API_KEY=" "$ENV_FILE"; then
            sed -i.bak "s|^NOTION_TOKEN=.*|NOTION_TOKEN=$NOTION_TOKEN|" "$ENV_FILE"
            sed -i.bak "s|^NOTION_API_KEY=.*|NOTION_API_KEY=$NOTION_TOKEN|" "$ENV_FILE"
            rm -f "$ENV_FILE.bak"
        else
            echo "NOTION_TOKEN=$NOTION_TOKEN" >> "$ENV_FILE"
        fi
    else
        echo "NOTION_TOKEN=$NOTION_TOKEN" > "$ENV_FILE"
    fi
    echo -e "${GREEN}✓ Token saved to .env${NC}"

    echo ""
    echo -e "${BLUE}Adding Notion MCP to Claude Code (local server)...${NC}"

    # Add local Notion MCP server via npx
    claude mcp add notion $SCOPE_FLAG \
        -e NOTION_TOKEN="$NOTION_TOKEN" \
        -- npx -y @notionhq/notion-mcp-server

    echo -e "${GREEN}✓ Notion MCP added with API token auth${NC}"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Step 2: Share Pages with the Integration${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "${YELLOW}⚠  This step is critical!${NC}"
    echo ""
    echo "Your Notion integration can ONLY access pages you explicitly share with it."
    echo ""
    echo "For each page or database you want MARVIN to access:"
    echo "  1. Open the page in Notion"
    echo "  2. Click the '...' menu → Connections"
    echo "  3. Add your integration (e.g., 'MARVIN')"
    echo ""
    echo "Tip: Sharing a parent page shares all child pages beneath it."
    echo ""
    read -p "Press Enter once you've shared your pages (or 's' to do this later)... " SHARE_RESPONSE

    if [[ "$SHARE_RESPONSE" == "s" || "$SHARE_RESPONSE" == "S" ]]; then
        echo ""
        echo -e "${YELLOW}Remember to share pages before trying to search or read them!${NC}"
    fi
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Try these commands with MARVIN:"
echo -e "  ${YELLOW}\"Search my Notion for meeting notes\"${NC}"
echo -e "  ${YELLOW}\"What's in my project tracker?\"${NC}"
echo -e "  ${YELLOW}\"Create a new page called 'Ideas'\"${NC}"
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
