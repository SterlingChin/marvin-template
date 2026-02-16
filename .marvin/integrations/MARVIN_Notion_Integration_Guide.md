# MARVIN Integration Guide: Notion

> **Status:** Implemented. The README.md and setup.sh have been extracted into
> `.marvin/integrations/notion/`. This document remains as a design reference
> covering MCP server details, auth rationale, the page-sharing permission
> model, environment variables, and testing checklists.

## Goal

Add a Notion integration to the MARVIN template so that MARVIN can interact with Notion (pages, databases, notes, knowledge base) via Notion's MCP server.

---

## Design References

1. **Integration pattern requirements:** `.marvin/integrations/CLAUDE.md` — 6 setup.sh rules, 9 README sections, Danger Zone format
2. **Contribution guidelines:** `.marvin/integrations/README.md`
3. **Remote MCP reference:** `.marvin/integrations/atlassian/`
4. **Local npx-based MCP reference:** `.marvin/integrations/slack/` — closest to Notion's recommended setup
5. Notion follows the Slack pattern: a local MCP server run via `npx` with an API token passed as an environment variable.

---

## MCP Server Details

Notion provides **two official MCP server options:**

### Option A — Official hosted remote MCP server (OAuth)

| Property | Value |
|----------|-------|
| **Endpoint** | `https://mcp.notion.com/mcp` |
| **Transport** | HTTP (streamable) |
| **Auth** | OAuth 2.1 — interactive browser flow |
| **Docs** | https://developers.notion.com/guides/mcp/get-started-with-mcp |

**Known issue:** Some users report the OAuth flow with Claude Code can be flaky and may require multiple attempts. If it doesn't work on first try, the local server option is more reliable.

### Option B — Official open-source local MCP server (recommended)

| Property | Value |
|----------|-------|
| **Package** | `@notionhq/notion-mcp-server` |
| **Transport** | stdio (via `npx`) |
| **Auth** | Internal integration token |
| **GitHub** | https://github.com/makenotion/notion-mcp-server |
| **Current version** | 2.0.0 (Notion API 2025-09-03, data sources as primary abstraction) |

**Why this is recommended:** More reliable than OAuth, gives you explicit control over which pages the integration can access, works in headless/remote environments, and doesn't depend on Notion's hosted MCP server availability.

### Why recommend the local server over OAuth?

1. **Reliability** — the local server runs via `npx` and connects directly to Notion's API. No intermediary OAuth server to be flaky.
2. **Explicit scope control** — with an internal integration token, you choose exactly which pages and databases to share. OAuth grants broader access.
3. **Headless-friendly** — API token works in any environment; OAuth needs a browser.
4. **Simpler debugging** — if something breaks, the error is between `npx` and the Notion API, not a three-party OAuth dance.

### How to create a Notion integration token

1. Go to https://www.notion.so/profile/integrations
2. Click **"New integration"**
3. Name it (e.g., `MARVIN`)
4. Select the workspace it should access
5. Under **Capabilities**, ensure "Read content", "Update content", and "Insert content" are enabled
6. Click **Submit** and copy the integration token (starts with `ntn_`)
7. **Critical step — share pages with the integration:**
   - Go to each Notion page or database you want MARVIN to access
   - Click the `...` menu → **Connections** → add your `MARVIN` integration
   - The integration can **only** see pages you explicitly share with it
   - Sharing a parent page shares all child pages beneath it

This page-sharing step is the **#1 source of "why can't MARVIN find my pages?"** issues. The setup script reminds users about it.

### Available MCP Tools (v2.0.0)

| Tool | What It Does |
|------|--------------|
| Search pages | Find pages and databases by text query |
| Retrieve page | Get full page content (blocks, properties, metadata) |
| Create page | Create new pages in a database or as children of another page |
| Update page | Modify page properties (title, status, tags, etc.) |
| Append blocks | Add content blocks (text, headings, lists, code, etc.) to existing pages |
| Query database | Filter and sort database entries with Notion's query syntax |
| Retrieve database | Get database schema, properties, and metadata |
| Create/read comments | Post and read comments on pages |
| Manage data source items | CRUD operations on data source entries (v2.0.0 abstraction) |

---

## Target Capabilities for MARVIN

Once connected, MARVIN should be able to:

- **Pull notes into context** — query a notes database, retrieve content, and use it in conversations and briefings
- **Update docs** — edit strategy docs, append meeting notes, update page properties
- **Search across Notion** — find relevant pages to pull context into conversations (e.g., "what did I write about the Q1 roadmap?")
- **Query databases with filters** — "show me all notes from this week tagged with 'modular'" or "what items in my project tracker are marked 'In Progress'?"
- **Create pages** — draft new docs, meeting notes, or knowledge base entries from conversation context
- **Add comments** — leave notes on pages for follow-up

---

## Implementation Files

Extracted into the proper directory structure:

```
.marvin/integrations/notion/
├── README.md       # User-facing docs (9 required sections)
└── setup.sh        # Interactive setup script (6 required patterns + Node.js check)
```

---

## Environment Variables

| Variable | Required? | Value | Where to get it |
|----------|-----------|-------|-----------------|
| `NOTION_TOKEN` | Only if using API token auth | `ntn_xxxxxxxxxxxx` | https://www.notion.so/profile/integrations |

**Note:** The `.env.example` currently uses `NOTION_API_KEY` as the variable name. For consistency with the official Notion MCP server (which expects `NOTION_TOKEN`), both names are handled by the setup script. Update `.env.example` to document both:

```
# Notion
NOTION_TOKEN=              # Internal integration token (for Notion MCP server)
NOTION_API_KEY=            # Alias — same value, used by some tools
```

---

## Repo Updates (completed)

- [x] `.marvin/integrations/README.md` — Added to the integrations table; removed from "Integration Ideas"
- [ ] Root `README.md` — Add row: `| [Notion](.marvin/integrations/notion/) | Pages, databases, notes | /help then follow prompts |`
- [ ] Root `CLAUDE.md` — Add row to integrations table: `| Notion | Pages, databases, notes |`
- [x] Safety Guidelines already covers Notion (existing "Publishing content" row lists "Confluence, Notion, blogs")

---

## Implementation Notes

- **Notion is more complex than Linear** primarily because of the page-sharing permission model. The integration token can be perfectly valid, but if the user hasn't shared pages with it in Notion's UI, every search returns empty. The setup script and README both emphasize this heavily.
- **The local `npx` server is recommended over OAuth** for reliability. The OAuth flow with Claude Code has been reported as flaky. The local server also gives better error messages when things go wrong.
- **Node.js is required** for the local server path. The setup script checks for this upfront (following the Slack integration pattern). The OAuth path does NOT need Node.js.
- **The `@notionhq/notion-mcp-server` package uses `NOTION_TOKEN`** as its environment variable, while `.env.example` currently has `NOTION_API_KEY`. The setup script writes both to `.env` for compatibility, and the `claude mcp add` command passes the correct one.
- **v2.0.0 introduced "data sources"** as the primary abstraction over databases. This simplifies querying and is the default behavior — no special configuration needed.
- **Notion databases are powerful** and MARVIN can leverage them for structured queries (filter by date, tag, status, person, etc.). This makes Notion especially useful as a knowledge base or task tracker that MARVIN can query during briefings.

---

## Testing Checklist

After implementation, verify these operations work:

- [ ] Search pages — `"Search my Notion for meeting notes"`
- [ ] Read a page — `"Show me the contents of my Roadmap page"`
- [ ] Create a page — `"Create a new Notion page called 'Test Page'"`
- [ ] Update a page — `"Add a heading to my Test Page: 'Section One'"`
- [ ] Query a database — `"Show all items in my tasks database with status 'In Progress'"`
- [ ] Handle missing permissions — searching for a page NOT shared with the integration returns a helpful message, not a crash
- [ ] MARVIN confirms before create/update/append actions (Danger Zone compliance)

---

## Conformance Checklist (from `.marvin/integrations/CLAUDE.md`)

- [x] `setup.sh` includes scope selection prompt
- [x] `setup.sh` uses correct color codes and banner format
- [x] `setup.sh` removes existing MCP before adding
- [x] `setup.sh` includes Node.js check (correct — local npx-based server)
- [x] `README.md` has all 9 required sections (Title, What It Does, Who It's For, Prerequisites, Setup, Try It, Danger Zone, Troubleshooting, Attribution)
- [x] Added integration to the table in `.marvin/integrations/README.md`
- [ ] Tested on a fresh install
