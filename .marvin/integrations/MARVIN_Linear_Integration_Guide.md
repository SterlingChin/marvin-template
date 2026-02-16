# MARVIN Integration Guide: Linear

> **Status:** Implemented. The README.md and setup.sh have been extracted into
> `.marvin/integrations/linear/`. This document remains as a design reference
> covering MCP server details, auth rationale, environment variables, and
> testing checklists.

## Goal

Add a Linear integration to the MARVIN template so that MARVIN can interact with Linear (project management — issues, projects, cycles, teams) via Linear's MCP server.

---

## Design References

1. **Integration pattern requirements:** `.marvin/integrations/CLAUDE.md` — 6 setup.sh rules, 9 README sections, Danger Zone format
2. **Contribution guidelines:** `.marvin/integrations/README.md`
3. **Closest reference implementation:** `.marvin/integrations/atlassian/` — remote MCP server, browser-based auth
4. Linear follows the Atlassian pattern: a remote MCP server with no local package installation required.

---

## MCP Server Details

Linear provides an **official remote MCP server** — no local `npx` package needed.

| Property | Value |
|----------|-------|
| **SSE endpoint** | `https://mcp.linear.app/sse` |
| **Streamable HTTP endpoint (preferred)** | `https://mcp.linear.app/mcp` |
| **Auth (Option A)** | OAuth 2.1 with dynamic client registration — interactive browser flow |
| **Auth (Option B)** | Linear API key via `Authorization: Bearer <token>` header |
| **Official docs** | https://linear.app/docs/mcp |

### Why two auth options?

- **OAuth (Option A)** is simplest for personal use — no token to manage, scopes handled automatically, browser popup authenticates in seconds. This is the same pattern Atlassian uses.
- **API key (Option B)** is better for headless/scripted setups or when you want explicit control over what the key can access. It also avoids the occasional flakiness of OAuth browser flows in terminal environments.

### How to generate a Linear API key

1. Open Linear → **Settings** → **Account** → **Security & Access** → **API Keys**
2. Click **Create Key**
3. Give it a descriptive name (e.g., `MARVIN`)
4. Copy the key — it starts with `lin_api_`
5. Store it in `.env` as `LINEAR_API_KEY`

### Available MCP Tools (provided by Linear's server)

Linear's MCP server exposes these tool categories (Linear is actively adding more):

| Tool | What It Does |
|------|--------------|
| Search issues | Find issues by text, filter, assignee, project, team |
| Get issue details | Retrieve full issue data (title, description, status, priority, labels, comments) |
| Create issues | Create new issues with title, description, assignee, priority, labels, project, team |
| Update issues | Change status, priority, assignee, labels, estimates, etc. |
| Add comments | Post comments on existing issues |
| Search projects | Find projects by name or team |
| List teams | Retrieve available teams and their identifiers |

---

## Target Capabilities for MARVIN

Once connected, MARVIN should be able to:

- **Create and assign tickets** — with team, project, priority, labels, and description pulled from conversation context
- **Update issue status** — move issues through workflow states (e.g., "mark LIN-42 as done")
- **Add context via comments** — post notes, decisions, or follow-ups directly to issues
- **Search and query issues** — find issues assigned to the user, filter by status/priority/project
- **Pull issue details into briefings** — during `/start`, surface open issues, blockers, or items nearing deadline
- **Work alongside Linear's Slack integration** — MARVIN creates/updates in Linear; Linear's own Slack app handles notifications automatically. No extra wiring needed.

---

## Implementation Files

Extracted into the proper directory structure:

```
.marvin/integrations/linear/
├── README.md       # User-facing docs (9 required sections)
└── setup.sh        # Interactive setup script (6 required patterns)
```

---

## Environment Variables

| Variable | Required? | Value | Where to get it |
|----------|-----------|-------|-----------------|
| `LINEAR_API_KEY` | Only if using API key auth | `lin_api_xxxxxxxxxxxx` | Linear → Settings → Account → Security & Access → API Keys |

Already present in `.env.example` — no changes needed there.

---

## Repo Updates (completed)

- [x] `.marvin/integrations/README.md` — Added to the integrations table; removed from "Integration Ideas"
- [ ] Root `README.md` — Add row: `| [Linear](.marvin/integrations/linear/) | Issues, projects, cycles | /help then follow prompts |`
- [ ] Root `CLAUDE.md` — Add row to integrations table: `| Linear | Issues, projects, cycles |`
- [x] Safety Guidelines already covers Linear (existing "Modifying tickets/issues" row lists "Jira, Linear, GitHub")

---

## Implementation Notes

- **Linear is the simpler integration.** It uses a remote MCP server (like Atlassian), so there's no local package to install, no Node.js dependency for the server itself, and no `npx` command. Start here before tackling Notion.
- **OAuth uses SSE transport; API key uses HTTP transport.** The SSE endpoint (`/sse`) supports the OAuth browser flow. The HTTP endpoint (`/mcp`) is for direct API key auth via headers. The setup script handles this branching.
- **No `mcp-remote` needed.** Unlike some MCP servers that require `npx @anthropic-ai/mcp-remote` as a bridge, Linear's SSE endpoint works directly with `claude mcp add --transport sse`.
- **Linear's Slack integration is separate.** When MARVIN creates or updates issues in Linear, Linear's own Slack app sends notifications. No extra configuration needed on MARVIN's side.
- **The setup script follows the Atlassian pattern closely** — the OAuth path mirrors Atlassian's browser auth flow, and the API key path adds the Slack-style token prompt on top.

---

## Testing Checklist

After implementation, verify these operations work:

- [ ] Search issues — `"Show my open Linear issues"`
- [ ] Create an issue — `"Create a bug: Login page crashes on mobile"`
- [ ] Update an issue — `"Mark ENG-47 as done"`
- [ ] Add a comment — `"Comment on ENG-47: Deployed the fix to staging"`
- [ ] Read issue details — `"What's the description of ENG-47?"`
- [ ] MARVIN confirms before create/update/comment actions (Danger Zone compliance)

---

## Conformance Checklist (from `.marvin/integrations/CLAUDE.md`)

- [x] `setup.sh` includes scope selection prompt
- [x] `setup.sh` uses correct color codes and banner format
- [x] `setup.sh` removes existing MCP before adding
- [x] `setup.sh` does NOT include Node.js check (correct — remote MCP, no npx)
- [x] `README.md` has all 9 required sections (Title, What It Does, Who It's For, Prerequisites, Setup, Try It, Danger Zone, Troubleshooting, Attribution)
- [x] Added integration to the table in `.marvin/integrations/README.md`
- [ ] Tested on a fresh install
