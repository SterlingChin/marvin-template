# Notion Integration

Connect MARVIN to your Notion workspace for pages, databases, and notes.

## What It Does

- **Search** — Find pages and databases across your connected workspace
- **Read** — View full page content, database entries, and properties
- **Create** — Make new pages and database entries
- **Update** — Edit page properties, append content blocks, modify entries
- **Query databases** — Filter and sort database entries (e.g., by date, tag, status)
- **Comment** — Add and read comments on pages

## Who It's For

Anyone who uses Notion for notes, documentation, wikis, project tracking, or as a knowledge base and wants MARVIN to read, search, and update their Notion workspace.

## Prerequisites

- A Notion account
- **Option A (recommended — API token):** A Notion internal integration token and Node.js installed (for `npx`)
- **Option B (OAuth):** Nothing else — the browser flow handles auth

## Setup

```bash
./.marvin/integrations/notion/setup.sh
```

The script will:
1. Check that Node.js is available (needed for the local MCP server)
2. Ask whether you want API token auth (recommended) or OAuth
3. If API token: prompt for the token, validate the format, and save it
4. Register the Notion MCP server with Claude Code
5. Remind you to share Notion pages with the integration

**Important:** After setup, you must share specific Notion pages/databases with your integration. The integration can only access pages you explicitly connect it to. See "Sharing Pages" below.

## Sharing Pages with the Integration

This is the most common setup mistake — the integration token is valid, but MARVIN can't find any pages because none have been shared.

**To share a page or database:**
1. Open the page in Notion
2. Click the `...` menu in the top-right corner
3. Click **Connections**
4. Search for and add your integration (e.g., `MARVIN`)

**Tips:**
- Sharing a parent page automatically shares all child pages beneath it
- Share your top-level workspace pages to give MARVIN broad access
- Or share only specific pages/databases for more targeted access

## Try It

After setup, try these commands with MARVIN:

- "Search my Notion for meeting notes"
- "What's in my project tracker database?"
- "Create a new Notion page called 'Weekly Review' under my notes"
- "Show me all entries in my tasks database tagged 'urgent'"
- "Add a section to my roadmap page about the new API integration"
- "What did I write about onboarding last week?"

## Danger Zone

This integration can perform actions that affect your shared Notion workspace:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Create pages | **Medium** | New pages appear in shared workspaces; collaborators may see them |
| Update pages | **Medium** | Changes are visible to all workspace collaborators |
| Append content | **Medium** | Adds blocks to existing pages; collaborators see changes |
| Add comments | **Medium** | Mentioned users and page followers get notified |
| Search and read pages | Low | No external impact |
| Query databases | Low | No external impact |

MARVIN will always confirm before creating, updating, or appending to pages.

## Troubleshooting

**"Can't find any pages" or empty search results**
- This is almost always a permissions issue. Make sure you've shared the pages/databases with your Notion integration (see "Sharing Pages" above).
- Sharing a parent page shares all its children — this is the fastest way to grant broad access.

**"Invalid token" or "Unauthorized"**
- Verify the token in `.env` starts with `ntn_` and hasn't been revoked
- Go to https://www.notion.so/profile/integrations and check that the integration is still active
- Generate a fresh token if needed and re-run the setup script

**"npx: command not found"**
- Install Node.js from https://nodejs.org (includes `npx`)
- Verify with: `node --version && npx --version`

**OAuth flow doesn't complete**
- The OAuth flow can be flaky with Claude Code. If it fails after 2-3 attempts, switch to the API token method — re-run the setup script and choose Option A.

**MCP server crashes or times out**
- Check your Node.js version: `node --version` (requires v18+)
- Try clearing the npx cache: `npx clear-npx-cache` then re-run setup
- Run `claude mcp list` to verify `notion` is registered

**Pages are outdated or stale**
- The MCP server fetches live data from Notion's API on each request — there's no cache. If content seems stale, the page may not have been saved in Notion yet.

---

*Contributed by Conor Bronsdon*
