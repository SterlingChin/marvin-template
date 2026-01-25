# MARVIN Integrations

This directory contains integrations that extend MARVIN's capabilities. Each integration connects MARVIN to external tools and services.

---

## Available Integrations

| Integration | Description | Setup |
|-------------|-------------|-------|
| [Google Workspace](./google-workspace/) | Gmail, Calendar, Drive | `./.marvin/integrations/google-workspace/setup.sh` |
| [Atlassian](./atlassian/) | Jira, Confluence | `./.marvin/integrations/atlassian/setup.sh` |
| [Parallel Search](./parallel-search/) | Web search | `./.marvin/integrations/parallel-search/setup.sh` |
| [Telegram](./telegram/) | Mobile AI assistant via Telegram | `./.marvin/integrations/telegram/setup.sh` |

---

## How to Install an Integration

1. Browse the folders in this directory (`.marvin/integrations/`)
2. Read the integration's README to see what it does
3. Run its setup script: `./.marvin/integrations/<name>/setup.sh`
4. Restart MARVIN and you're good to go!

Or just ask MARVIN: *"Help me set up the Notion integration"*

---

## Request an Integration

Want MARVIN to connect to a tool that's not here yet?

**Option 1:** Open an issue on GitHub describing what you'd like

**Option 2:** Add it to `.marvin/integrations/REQUESTS.md` and submit a PR

**Option 3:** Build it yourself! See "Contributing" below.

---

## Contributing an Integration

We'd love community contributions! If you've set up MARVIN with a tool you love, share it with others.

### Integration Structure

Each integration should have its own folder:

```
.marvin/integrations/
└── your-integration/
    ├── README.md      # Documentation (required sections below)
    ├── setup.sh       # Setup script (required patterns below)
    └── ...            # Any additional files needed
```

### Setup Script Requirements

Your `setup.sh` must follow these patterns for consistency:

**1. Standard header and colors:**
```bash
#!/bin/bash
# Your Integration MCP Setup Script
# Brief description

set -e

# Colors for output (use these exact definitions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
```

**2. Banner format:**
```bash
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Your Integration Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
```

**3. Check for Claude Code:**
```bash
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code installed${NC}"
else
    echo -e "${RED}✗ Claude Code not found${NC}"
    echo "Install with: npm install -g @anthropic-ai/claude-code"
    exit 1
fi
```

**4. Scope selection (REQUIRED):**

Users must choose whether the MCP is available globally or per-project:

```bash
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
```

Then use `$SCOPE_FLAG` in your `claude mcp add` command:
```bash
claude mcp add your-integration $SCOPE_FLAG ...
```

**5. Remove existing before adding:**
```bash
claude mcp remove your-integration 2>/dev/null || true
```

**6. End with "Setup Complete" banner and example commands:**
```bash
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Try these commands with MARVIN:"
echo -e "  ${YELLOW}\"Example command 1\"${NC}"
echo -e "  ${YELLOW}\"Example command 2\"${NC}"
echo ""
echo -e "${GREEN}You're all set!${NC}"
echo ""
```

### README Requirements

Your README.md must include these sections:

| Section | Description |
|---------|-------------|
| **What It Does** | Bullet list of capabilities |
| **Who It's For** | Target audience |
| **Prerequisites** | Required accounts, permissions, etc. |
| **Setup** | Code block with setup command |
| **Try It** | Example commands to test |
| **Danger Zone** | What actions can affect others or can't be undone (see below) |
| **Troubleshooting** | Common issues and solutions |

End with an attribution line: `*Contributed by Your Name*`

### Danger Zone Section (Required)

Every integration README must include a "Danger Zone" section that clearly documents:
- **What write/send/delete actions are possible**
- **Who could be affected** (team members, external contacts, etc.)
- **What can't be undone**

This helps users understand the risks before enabling an integration.

**Example Danger Zone section:**

```markdown
## Danger Zone

This integration can perform actions that affect others or can't be easily undone:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Send emails | High | Recipients see it immediately |
| Delete files | High | Data loss may be permanent |
| Modify calendar | Medium | Other attendees are notified |
| Read messages | Low | No external impact |

MARVIN will always confirm before performing high-risk actions.
```

### Example README.md

```markdown
# Notion Integration

Connect MARVIN to your Notion workspace.

## What It Does

- **Search** - Find pages and databases
- **Read** - View page content
- **Create** - Make new pages
- **Update** - Edit existing pages

## Who It's For

Anyone who uses Notion for notes, wikis, or project management.

## Prerequisites

- A Notion account
- A Notion integration token (the setup script will guide you)

## Setup

\`\`\`bash
./.marvin/integrations/notion/setup.sh
\`\`\`

## Try It

After setup, try these commands with MARVIN:

- "Search my Notion for meeting notes"
- "What's in my project tracker?"
- "Create a new page called 'Ideas'"

## Troubleshooting

**Can't find pages**
Make sure you've shared the pages with your Notion integration.

**Token errors**
Re-run the setup script and copy a fresh token.

---

*Contributed by Your Name*
```

### Other Guidelines

1. **Make it easy** - Assume the user is non-technical. Use colors, clear prompts, and helpful error messages.

2. **Be safe** - Never store credentials in plain text. Use environment variables or Claude's MCP config.

3. **Test it** - Make sure it works on a fresh install.

4. **Update the table** - Add your integration to the "Available Integrations" table at the top of this file.

---

## Integration Ideas

Here are some integrations we'd love to see:

- **Notion** - Notes, wikis, databases
- **Slack** - Team messaging
- **Linear** - Issue tracking
- **Figma** - Design files
- **Airtable** - Spreadsheets and databases
- **HubSpot** - CRM
- **Todoist** - Task management
- **Obsidian** - Local markdown notes
- **Raycast** - Quick actions
- **Granola** - Meeting notes

Want to build one? Pick from the list or add your own!

---

*This integrations directory is part of [MARVIN](https://github.com/SterlingChin/marvin-template), the AI Chief of Staff template.*
