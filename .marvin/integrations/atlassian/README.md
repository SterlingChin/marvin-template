# Atlassian Integration

Connect MARVIN to Jira and Confluence.

## What It Does

- **Jira** - View tickets, search issues, check sprint status
- **Confluence** - Search documentation, read pages

## Who It's For

Teams that use Atlassian products for project management and documentation.

## Prerequisites

- An Atlassian account (Jira and/or Confluence)
- Access to the Atlassian workspace you want to connect

## Setup

```bash
./integrations/atlassian/setup.sh
```

The script will:
1. Configure the Atlassian MCP server
2. Open a browser for you to log in with your Atlassian account

## Try It

After setup, try these commands with MARVIN:

- "Show me my open Jira tickets"
- "What's the status of PROJECT-123?"
- "Search Confluence for onboarding docs"
- "What tickets are in the current sprint?"
- "Find Jira issues assigned to me"

## Danger Zone

This integration can perform actions that affect your team:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Modify Jira tickets | **Medium** | Team sees changes, notifications sent |
| Edit Confluence pages | **Medium** | Team sees changes in shared docs |
| Create issues/pages | Low | Creates new items, doesn't affect existing |
| Read tickets, pages, search | Low | No external impact |

**MARVIN will always confirm before modifying tickets or editing pages.**

## Troubleshooting

**Browser doesn't open for login**
Try running the setup script again, or restart Claude Code.

**"Unauthorized" errors**
Make sure you're logging in with an account that has access to the Jira/Confluence workspace.

**Can't find your workspace**
The first time you use Jira or Confluence commands, you may need to select which Atlassian site to connect to.

---

*Created by Sterling Chin*
