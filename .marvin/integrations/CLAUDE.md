# Integration Development Guidelines

When helping a user create a new MARVIN integration, follow these requirements exactly.

## Setup Script Requirements

Every `setup.sh` MUST include:

### 1. Standard header
```bash
#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
```

### 2. Claude Code check
```bash
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code installed${NC}"
else
    echo -e "${RED}✗ Claude Code not found${NC}"
    echo "Install with: npm install -g @anthropic-ai/claude-code"
    exit 1
fi
```

### 3. Scope selection (REQUIRED - do not skip)
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

Then use `$SCOPE_FLAG` in the `claude mcp add` command:
```bash
claude mcp add integration-name $SCOPE_FLAG ...
```

### 4. Remove before add
```bash
claude mcp remove integration-name 2>/dev/null || true
```

### 5. Blue banners for sections
```bash
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Section Title${NC}"
echo -e "${BLUE}========================================${NC}"
```

### 6. End with success message
```bash
echo -e "${GREEN}You're all set!${NC}"
```

## README Requirements

Every integration README.md MUST have these sections in order:

1. **Title** - `# Integration Name`
2. **What It Does** - Bullet list of capabilities
3. **Who It's For** - Target audience
4. **Prerequisites** - Required accounts, API keys, permissions
5. **Setup** - Code block with the setup command
6. **Try It** - Example commands users can try
7. **Danger Zone** - Actions that affect others or can't be undone (REQUIRED)
8. **Troubleshooting** - Common issues and solutions
9. **Attribution** - `*Contributed by Name*` at the bottom

## Danger Zone Section (REQUIRED)

Every integration MUST document risky actions. Use this format:

```markdown
## Danger Zone

This integration can perform actions that affect others or can't be easily undone:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Send emails | High | Recipients see immediately |
| Delete files | High | Data loss may be permanent |
| Read data | Low | No external impact |

MARVIN will always confirm before performing high-risk actions.
```

If an integration is read-only, still include the section stating "This integration is read-only and cannot modify external data."

## Checklist Before Submitting

- [ ] `setup.sh` includes scope selection prompt
- [ ] `setup.sh` uses correct color codes and banner format
- [ ] `setup.sh` removes existing MCP before adding
- [ ] `README.md` has all required sections
- [ ] Added integration to the table in `.marvin/integrations/README.md`
- [ ] Tested on a fresh install

## Reference

See existing integrations for examples:
- `atlassian/` - Simple remote MCP server
- `google-workspace/` - OAuth-based integration
- `parallel-search/` - Remote MCP server

Full documentation: `README.md` in this directory
