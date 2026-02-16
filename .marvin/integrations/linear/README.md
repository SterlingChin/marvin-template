# Linear Integration

Connect MARVIN to Linear for issue tracking and project management.

## What It Does

- **Search issues** — Find issues by keyword, assignee, status, project, or team
- **Create issues** — File new issues with title, description, priority, labels, and assignee
- **Update issues** — Change status, priority, assignee, and other fields
- **Comment on issues** — Add notes and context to existing issues
- **Browse projects and teams** — List projects, cycles, and team structures

## Who It's For

Anyone who uses Linear for project management and wants MARVIN to create, search, and update issues as part of their daily workflow.

## Prerequisites

- A Linear account with access to the workspace you want to connect
- **Option A (OAuth):** Nothing else — the browser flow handles auth
- **Option B (API key):** A Linear API key (the setup script will guide you)

## Setup

```bash
./.marvin/integrations/linear/setup.sh
```

The script will:
1. Ask whether you want OAuth (browser flow) or API key auth
2. If API key: prompt for your key, validate the format, and save it
3. Register the Linear MCP server with Claude Code
4. Walk you through authentication if using OAuth

## Try It

After setup, try these commands with MARVIN:

- "Show me my open Linear issues"
- "Create a Linear issue: Update the onboarding flow — priority high, assign to me"
- "What's the status of ENG-47?"
- "Add a comment to ENG-47: Decided to use the new API endpoint instead"
- "Search Linear for issues about authentication"
- "What issues are in the current cycle?"

## Danger Zone

This integration can perform actions that affect your team:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Create issues | **Medium** | Team sees new issues, may get notifications |
| Update issues (status, assignee, priority) | **Medium** | Team sees changes, workflow automations may trigger |
| Add comments | **Medium** | Mentioned users and subscribers get notified |
| Search and read issues | Low | No external impact |

MARVIN will always confirm before creating, updating, or commenting on issues.

## Troubleshooting

**"Unauthorized" or "Authentication failed"**
- **OAuth:** Re-authenticate by running `claude mcp` → select `linear` → choose "Authenticate" → complete the browser flow
- **API key:** Verify the key is correct in `.env` and hasn't been revoked. Generate a new one at Linear → Settings → Account → Security & Access → API Keys.

**Can't find issues or projects**
- Make sure you're authenticated to the correct Linear workspace
- Check that your account has access to the team/project you're querying

**OAuth browser flow doesn't open**
- Try the API key option instead — run the setup script again and choose Option B
- If using a remote/headless environment, the API key approach is more reliable

**"MCP server not found" after setup**
- Restart Claude Code after running the setup script
- Run `claude mcp list` to verify `linear` appears in the server list

---

*Contributed by Conor Bronsdon*
