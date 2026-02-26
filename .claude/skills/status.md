---
name: status
description: Check integration health and workspace status. Tests each configured MCP integration with a read-only probe, reports workspace health, and shows available but unconfigured integrations.
---

# Status Check

Check integration health and MARVIN workspace status at a glance.

## When to Use

Claude Code should invoke this skill when:
- User types `/status`
- User asks "what integrations are working?" or "is everything connected?"
- When debugging integration issues
- After setting up a new integration to verify it works

## How It Works

### Step 1: Discover Configured Integrations

Run `claude mcp list` to get all configured MCP servers. Map each to known integrations:

| MCP Server Name | Integration | Capabilities |
|----------------|-------------|--------------|
| `atlassian` | Atlassian | Jira, Confluence |
| `google-workspace` | Google Workspace | Gmail, Calendar, Drive |
| `ms365` | Microsoft 365 | Outlook, Calendar, OneDrive, Teams |
| `parallel-search` | Web Search | Search, URL fetching |
| `slack` | Slack | Messages, channels, search |
| `notion` | Notion | Pages, databases |
| `linear` | Linear | Issues, projects |
| `telegram` | Telegram | Mobile messaging |

Any unrecognized MCP server should be listed as "Custom" with its actual name.

### Step 2: Test Each Integration

For each configured integration, perform a **lightweight, read-only** test:

- **Atlassian** → Search for recent Jira issues
- **Google Workspace** → List recent emails or calendar events
- **MS365** → List recent emails or calendar events
- **Parallel Search** → Run a trivial web search
- **Slack** → List channels
- **Notion** → Search for pages
- **Linear** → List recent issues

Classify results:
- **Connected** (✅) → Test succeeded, integration is working
- **Error** (❌) → Test failed with a specific error (auth expired, network issue, etc.)
- **Configured** (⚙️) → Installed but can't be easily tested (e.g., Telegram standalone process)

**Critical:** Never send, create, modify, or delete anything during tests. Read-only operations only.

### Step 3: Check Workspace Health

Verify these components:

1. **User Profile** — Is the profile section in CLAUDE.md filled in (not "NOT CONFIGURED")?
2. **State Files** — Do `state/current.md` and `state/goals.md` contain real content (not placeholders)?
3. **Session Recency** — When was the last session log in `sessions/`? Flag if >7 days.
4. **Git Status** — Is the workspace a git repo? Any uncommitted changes?
5. **Goals** — Are there active goals in `state/goals.md`?

### Step 4: Identify Available Integrations

Check which integrations exist in `.marvin/integrations/` but are NOT in the configured MCP list. These are "available but not installed."

### Step 5: Present Report

Format the output as a clear status dashboard.

## Output Format

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
| MS365       | ❌ Error | Authentication expired - run `claude mcp` to re-auth |

### Workspace

| Component | Status |
|-----------|--------|
| User Profile | ✅ Configured |
| State Files  | ✅ Current |
| Last Session | 2 days ago (2026-02-14) |
| Git          | ✅ Clean (3 commits ahead of remote) |
| Goals        | ✅ 4 active goals |

### Available (Not Installed)

| Integration | Setup Command |
|-------------|---------------|
| Google Workspace | `./.marvin/integrations/google-workspace/setup.sh` |
| Telegram | `./.marvin/integrations/telegram/setup.sh` |

---

Anything you'd like me to fix or set up?
```

Adapt the report to what's actually found. Skip sections that are empty.

## Notes

- This is a diagnostic tool — never modify state or integrations during a status check
- If errors are found, offer to help fix them after presenting the full report
- If no integrations are configured at all, suggest the user start with one and offer to help
