# Team Setup Guide

How to set up MARVIN team mode for your team. Team mode gives every MARVIN instance shared awareness through your existing tools.

## Quick Start for Team Leads

1. **Run `/team init`** inside MARVIN
2. **Follow the prompts:** team name, communication tool, knowledge base, work tracker, roles
3. **Share `.marvin-team/`** with your team (git, file share, Dropbox, whatever works)
4. **Run `/start`** to verify your team briefing appears

That's it. Your team members install the same `.marvin-team/` directory and run `/team join`.

## Quick Start for Team Members

1. **Get `.marvin-team/`** from your team lead
2. **Copy it** into your MARVIN workspace root
3. **Run `/team join`** inside MARVIN
4. **Pick your role** when prompted (Engineer, PM, EM, or skip)
5. **Run `/start`** to see your team briefing

## Configuration Reference

All team configuration lives in `.marvin-team/team.yaml`. Here's every field:

### Team Identity

```yaml
team:
  name: "Platform Engineering"    # Your team name, shown in briefings
```

### Shared Context: Communication

```yaml
shared_context:
  slack:
    digest_channel: "#eng-marvin-updates"   # Where digests are posted
    monitor_channels:                        # Channels MARVIN reads for context
      - "#eng-general"
      - "#eng-blockers"
```

### Shared Context: Knowledge Base

Configure one or more. These are where team decisions and priorities are stored.

**Google Docs:**
```yaml
  google:
    priorities_doc_id: "1abc..."       # Google Doc ID for team priorities
    decisions_doc_id: "1def..."        # Google Doc ID for decision log
    team_state_doc_id: "1ghi..."       # Google Doc ID for shared team state
```

**Confluence:**
```yaml
  confluence:
    space: "ENG"                       # Confluence space key
    decisions_page_id: "12345"         # Page ID for decision log
    priorities_page_id: "12346"        # Page ID for priorities
```

**Notion:**
```yaml
  notion:
    priorities_page_id: "abc-123"      # Notion page ID for priorities
    decisions_database_id: "def-456"   # Notion database ID for decisions
```

### Shared Context: Work Tracking

Configure one. This is where your team tracks tasks and projects.

**Jira:**
```yaml
  jira:
    projects:
      - key: "ENG"
        name: "Engineering"
      - key: "INFRA"
        name: "Infrastructure"
```

**Linear:**
```yaml
  linear:
    team_id: "team_abc123"
```

**GitHub:**
```yaml
  github:
    repos:
      - "your-org/your-repo"
      - "your-org/another-repo"
```

### Behaviors

What MARVIN does with shared context at session boundaries.

```yaml
behaviors:
  on_start:                          # Actions when you run /start
    - read_team_priorities           # Fetch priorities doc/page
    - read_recent_digests            # Check teammate digests since last session
    - check_team_blockers            # Surface active blockers

  on_end:                            # Actions when you run /end
    - post_digest                    # Draft and post session digest
    - update_decisions               # Update shared decisions if any made
    - update_blockers                # Update blockers if raised/resolved
```

### Digest Settings

```yaml
  digest:
    format: "digest/format.md"       # Template for digest formatting
    post_to: "slack"                 # Where to post: "slack", "google", "confluence", "notion"
    require_approval: true           # Ask before posting (recommended, default)
```

### Inngest (Optional)

For push-based team events instead of pull-based reading on `/start`.

```yaml
inngest:
  enabled: true
  app_id: "your-inngest-app-id"
  events:
    on_digest_posted: "marvin/digest.posted"
    on_blocker_raised: "marvin/blocker.raised"
    on_blocker_resolved: "marvin/blocker.resolved"
    on_decision_made: "marvin/decision.made"
  runtime: "inngest-cloud"           # or "ccr", "vercel", "cloudflare"
```

## Role Profile Reference

### What Roles Do

Roles prioritize, not restrict. Every MARVIN sees the same shared data. A role changes what surfaces first in your briefing and what gets emphasized in digest context.

For example, an Engineer role surfaces PRs and incidents first. A PM role surfaces epics and timelines first. Both can see everything.

### Available Presets

**Engineer** (`roles/engineer.yaml`):
- Priorities: PRs awaiting review, bugs assigned, active incidents, deployment status
- Context sources: GitHub, Jira bugs, incident channels

**Program Manager** (`roles/pm.yaml`):
- Priorities: Epic progress, cross-team dependencies, risks, timeline changes
- Context sources: Jira epics, project docs, stakeholder updates

**Engineering Manager** (`roles/em.yaml`):
- Priorities: Team velocity trends, active blockers, open headcount, process issues
- Context sources: Sprint metrics, blocker channels, team health signals

### Creating Custom Roles

1. Copy `roles/_template.yaml` to `roles/your-role.yaml`
2. Set the role name and description
3. Define `priorities` (what to surface first)
4. Define `context_sources` (where to look)
5. Share the updated `.marvin-team/` directory with your team

Any YAML file in `roles/` (except `_template.yaml`) becomes an available role when running `/team join`.

### Changing Your Role

Run `/team join` again and select a different role. Your `my-role.yaml` is updated locally. No impact on other team members.

## Troubleshooting

### "Tool not connected"

The tool is configured in `team.yaml` but MARVIN can't reach it.

**Slack:** Install the Slack MCP server or verify it's running. Check that the configured channels exist and MARVIN has access.

**Google Docs:** Verify the `gws` CLI is installed and authenticated, or that the Google Workspace MCP is connected. Check that the doc IDs in `team.yaml` are correct and accessible.

**Confluence/Jira:** Verify the Atlassian MCP server is connected. Check that space keys, project keys, and page IDs are correct.

**Notion:** Verify the Notion MCP server is connected. Check that page and database IDs are correct and shared with the integration.

**Linear:** Verify the Linear MCP server is connected. Check that the team ID is correct.

**GitHub:** Verify the `gh` CLI is installed and authenticated (`gh auth status`). Check that repo names are correct.

### "Digest not posting"

1. Check the `post_to` field in `team.yaml` matches a configured tool
2. Verify the tool is connected (run `/team status`)
3. Check that the digest destination exists (Slack channel, Google Doc, Confluence page)
4. If `require_approval` is true, make sure you're approving when prompted at `/end`

### "Not seeing team updates"

1. Verify the digest channel or doc is the same one your teammates are posting to
2. Check that teammates have actually posted digests (run `/team status` to see recent activity)
3. Verify your `on_start` behaviors include `read_recent_digests`
4. Make sure your tool connections are working

### "Role not applied"

1. Check that `my-role.yaml` exists in `.marvin-team/`
2. Verify the role name matches a file in `roles/` (case-sensitive)
3. Run `/team join` again to re-select your role
4. Run `/start` to verify the role appears in your briefing

## FAQ

**Can I be on multiple teams?**
Not yet. One `.marvin-team/` plugin per workspace. If you need multiple teams, use separate MARVIN workspaces (git worktrees work well for this).

**Can I change my role?**
Yes. Run `/team join` again and select a different role. Your `my-role.yaml` is updated immediately.

**What if I don't want to post digests?**
Decline when prompted at `/end`, or skip the `/end` team step entirely. Digest posting is always opt-in when `require_approval` is true (the default).

**Does team mode affect my personal MARVIN?**
No. Team mode is purely additive. Your personal briefing, session logs, and state files work exactly the same. Team mode adds a TEAM section to your `/start` briefing and a digest step to `/end`.

**What data is shared?**
Only what you approve. Session digests summarize what you worked on, decisions made, and blockers. They're drafted by MARVIN and require your approval before posting. No raw session logs, personal state, or private notes are shared.

**Can I use team mode without any external tools?**
Not meaningfully. Team mode's value comes from connecting to shared surfaces. Without at least one tool (Slack, Google Docs, etc.), there's nowhere for digests to go and nothing for `/start` to read.

**How do I remove team mode?**
Delete the `.marvin-team/` directory (except `_template/` if you want to keep it for later). Team mode deactivates automatically when `team.yaml` is absent.
