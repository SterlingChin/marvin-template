---
name: team-awareness
description: "Read and write team shared context for multi-MARVIN coordination. Activated when .marvin-team/team.yaml exists. Reads team digests, decisions, and blockers on /start. Drafts and posts team digests on /end."
---

# Team Awareness

Provides shared context between multiple MARVIN instances on the same team. Each team member runs their own MARVIN locally. This skill handles reading from and writing to the team's shared context surfaces.

## When to Use

Claude Code should invoke this skill when:
- `/start` runs and `.marvin-team/team.yaml` exists (read team context)
- `/end` runs and `.marvin-team/team.yaml` exists (draft and post digest)
- User asks about team activity ("what's the team working on?", "any blockers?")
- User asks to post a team update manually

## When NOT to Use

- `.marvin-team/team.yaml` does not exist (solo mode, no team features)
- User explicitly says they don't want team updates this session

## Detection

Check for `.marvin-team/team.yaml` in the workspace root. If present, team mode is active. If absent, skip all team behaviors silently.

## Configuration Loading

Read `.marvin-team/team.yaml` and extract:
- `team.name` — team name for display
- `shared_context.*` — which tools are configured and their connection details
- `behaviors.*` — what to do on start and end
- `behaviors.digest.post_to` — where to post digests
- `behaviors.digest.require_approval` — whether to confirm before posting (should always be true)

Read `.marvin-team/my-role.yaml` if it exists (local role selection):
- `role` — role name
- `focus.*` — prioritization filters

## Reading Team Context (on /start)

For each behavior listed in `behaviors.on_start`, execute the corresponding action:

### read_team_priorities

Read the team's shared priorities from the configured knowledge base:

**Google Docs:**
```bash
# Using gws CLI
GOOGLE_WORKSPACE_CLI_CONFIG_DIR=~/.config/gws gws drive export <priorities_doc_id> --format text
```
Or use Google Workspace MCP if available.

**Confluence:**
Use Atlassian MCP: `getConfluencePage` with `shared_context.confluence.priorities_page_id`

**Notion:**
Use Notion MCP to read `shared_context.notion.priorities_page_id`

### read_recent_digests

Read recent team digests from the configured communication channel:

**Slack:**
Use Slack MCP to read recent messages from `shared_context.slack.digest_channel`. Look for digest-formatted messages from other team members posted since your last session.

**Google Docs:**
```bash
GOOGLE_WORKSPACE_CLI_CONFIG_DIR=~/.config/gws gws drive export <team_state_doc_id> --format text
```
Parse the doc for recent digest entries. Each digest follows the format in `digest/format.md`.

**Confluence:**
Read the team state page and parse recent digest entries.

### check_team_blockers

Scan for active blockers across configured tools:

**Jira:**
Use Atlassian MCP with JQL: `project in ({project_keys}) AND status = Blocked ORDER BY priority DESC`

**Linear:**
Use Linear MCP to query blocked issues for the team.

**From digests:**
Parse recent digests for "Blockers:" sections.

### Role-Based Filtering

If `.marvin-team/my-role.yaml` exists, apply role-specific prioritization:
- Use `focus.jira_filters` to customize which Jira issues are surfaced
- Use `focus.slack_priority_channels` to prioritize certain channels
- Use `focus.digest_emphasis` to shape how the team section is summarized

Role filtering changes what's **emphasized**, not what's **visible**. All team data is available; the role determines what leads the briefing.

### Output Format (for /start TEAM section)

```
**TEAM**
Since your last session:
- {N digests posted (list member names)}
- {Decisions: "topic" (by who, when)}
- {Blockers: "what" (raised by who, how long ago)}
- {Items needing your input}
{If nothing new: "Team: no updates since your last session."}
```

## Writing Team Context (on /end)

For each behavior listed in `behaviors.on_end`, execute the corresponding action:

### post_digest

1. Read `.marvin-team/_template/digest/format.md` for the digest template
2. From the current session, extract:
   - Shipped items (completed work, merged PRs)
   - In-progress work
   - Decisions made (with brief rationale)
   - Blockers raised or resolved
3. Draft the digest following the format template
4. Read the user's name from `CLAUDE.md` User Profile section
5. Present the draft to the user:

```
Team digest for [destination]:

## **[Name] — [Date]**

**Shipped:**
- {items}

**In Progress:**
- {items}

**Decisions:**
- {items}

**Blockers:**
- {items}

Post this to [destination]? (y/n)
```

6. **CRITICAL: Wait for explicit approval. NEVER auto-post.**
7. If approved, post to the configured destination:

**Slack:**
Use Slack MCP to post to `shared_context.slack.digest_channel`.

**Google Docs:**
```bash
# Append to team state doc
GOOGLE_WORKSPACE_CLI_CONFIG_DIR=~/.config/gws gws docs append <team_state_doc_id> --content "..."
```
Or use Google Workspace MCP. Append the digest to the end of the doc with a separator.

**Confluence:**
Use Atlassian MCP to append to the team state page.

**Notion:**
Use Notion MCP to add an entry to the configured database.

8. If declined, skip posting and note "Team digest skipped" in the session log.

### update_decisions

If any decisions were made during this session:
1. Format each decision: topic, what was decided, brief rationale
2. Append to the shared decisions doc/page:

**Google Docs:** Append to `shared_context.google.decisions_doc_id`
**Confluence:** Append to `shared_context.confluence.decisions_page_id`
**Notion:** Add entry to `shared_context.notion.decisions_database_id`

This happens automatically after digest posting. No separate approval needed (the decision content was already visible in the digest).

### update_blockers

If blockers were raised or resolved during this session:
- For raised blockers: note what's blocked, who raised it, what's needed to unblock
- For resolved blockers: note what was unblocked and how

Update in the same shared context surface as digests. Blockers should be clearly marked so other MARVINs can surface them.

## Tool Routing

The skill reads `team.yaml` and routes to the correct tool. Available tools:

| Configured In | Tool to Use | Fallback |
|--------------|-------------|----------|
| `shared_context.google` | `gws` CLI | Google Workspace MCP |
| `shared_context.slack` | Slack MCP | n/a |
| `shared_context.confluence` | Atlassian MCP | n/a |
| `shared_context.jira` | Atlassian MCP | n/a |
| `shared_context.notion` | Notion MCP | n/a |
| `shared_context.linear` | Linear MCP | n/a |
| `shared_context.github` | `gh` CLI | n/a |

**Prefer CLI tools over MCP when both are available** (consistent with MARVIN's CLI-first integration philosophy).

## Error Handling

If a configured tool is not available (MCP not connected, CLI not installed):
- Note it in the briefing: "Team mode: couldn't read Slack (not connected). Google Docs loaded."
- Don't fail the entire team context load. Partial data is better than none.
- For digest posting: if the configured destination is unavailable, tell the user and offer to save the digest locally instead.

## Inngest Events (Optional)

If `inngest.enabled` is `true` in `team.yaml`, emit events after posting:
- After digest posted: emit `marvin/digest.posted` with digest content
- After blocker raised: emit `marvin/blocker.raised` with blocker details
- After blocker resolved: emit `marvin/blocker.resolved`
- After decision made: emit `marvin/decision.made`

If Inngest is not configured, skip event emission silently.

## Notes

- Team mode is purely additive. It never changes personal MARVIN behavior.
- Digests ALWAYS require user approval before posting. This is not configurable to false.
- Role filtering is optional. Without a role, all team data is shown equally.
- The skill should be lightweight on startup. Don't block the briefing on slow API calls. If a tool takes too long, skip it and note the timeout.
