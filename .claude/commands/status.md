---
description: Check integration health and MARVIN workspace status
---

# /status - MARVIN Status Check

Check what integrations are connected and whether they're working, plus workspace health.

## Instructions

### 1. Check MCP Integrations

Run this command to list configured MCP servers:
```bash
claude mcp list
```

For each configured MCP server, determine:
- **Name** - The server name
- **Type** - What kind of integration (remote HTTP, local process, etc.)
- **Category** - Map to known integrations (see table below)

### 2. Test Each Integration

For each configured integration, run a lightweight read-only test to verify it's actually working. Use the mapping below to determine what to test:

| MCP Server Name | Integration | Test Action |
|----------------|-------------|-------------|
| `atlassian` | Atlassian (Jira/Confluence) | Try listing recent Jira issues or searching Confluence |
| `google-workspace` | Google Workspace | Try listing recent emails or checking calendar |
| `ms365` | Microsoft 365 | Try listing recent emails or checking calendar |
| `parallel-search` | Web Search | Try a simple web search |
| `slack` (or custom) | Slack | Try listing channels |
| `notion` | Notion | Try searching pages |
| `linear` | Linear | Try listing issues |

**Important:** Only perform **read-only** operations. Never send, create, or modify anything during status checks.

If a test succeeds, mark the integration as **Connected**.
If a test fails (auth error, timeout, etc.), mark it as **Error** and note what went wrong.
If it can't be tested easily, mark it as **Configured** (installed but unverified).

### 3. Check Workspace Health

Verify the MARVIN workspace is set up properly:

- **State files** - Do `state/current.md` and `state/goals.md` exist and have real content (not just placeholders)?
- **Session logs** - Is there a recent session log in `sessions/`? How many days since the last session?
- **Git status** - Is the workspace a git repo? Any uncommitted changes?
- **User profile** - Is the CLAUDE.md user profile section configured?

### 4. Present Status Report

Display a clear status report:

```
## MARVIN Status

### Integrations

| Integration | Status | Details |
|-------------|--------|---------|
| Atlassian   | ✅ Connected | Jira + Confluence accessible |
| Notion      | ✅ Connected | 24 pages found |
| Linear      | ✅ Connected | 8 active issues |
| Slack       | ✅ Connected | 12 channels visible |
| Web Search  | ✅ Connected | parallel-search working |
| MS365       | ❌ Error | Authentication expired |

### Workspace

| Component | Status |
|-----------|--------|
| User Profile | ✅ Configured |
| State Files  | ✅ Current |
| Last Session | 2 days ago (2026-02-14) |
| Git          | ✅ Clean |

### Available (Not Installed)

These integrations are available but not yet configured:
- Google Workspace - `./.marvin/integrations/google-workspace/setup.sh`
- Telegram - `./.marvin/integrations/telegram/setup.sh`
```

Adjust the report based on what's actually found. Only show the "Available" section if there are uninstalled integrations.

### 5. Offer Help

If any integrations show errors, offer to help fix them.
If workspace health issues are found, offer to help resolve them.
If no integrations are configured, suggest setting one up.

End with: "Anything you'd like me to fix or set up?"
