# Setting Up MARVIN Teams -- Leader Guide

This guide walks you through creating a team plugin for your team. Run `/team init` inside MARVIN to start the interactive setup, or follow these steps manually.

MARVIN reads this document when running `/team init` to guide you through each step. It's also readable on its own if you prefer to set things up by hand.

## Before You Start

What you'll need:

- A shared communication channel (Slack, or a shared doc for digests)
- A knowledge base for team decisions and priorities (Notion, Confluence, Google Docs, or an Obsidian vault)
- A work tracking system (Linear, Jira, or GitHub Issues). Optional but recommended.
- Know your team's roles (who are the engineers, PMs, EMs?)

You do not need all of these on day one. One shared surface is enough to start.

## Step 1: Choose Your Shared Context Tools

MARVIN Teams is tool-agnostic. Pick the tools your team already uses:

| Purpose | Options | What MARVIN Does With It |
|---------|---------|--------------------------|
| Team digests | Slack channel, Notion page, Confluence page, Obsidian vault | Posts daily session summaries |
| Priorities and decisions | Notion, Confluence, Google Docs, Obsidian | Reads team priorities on `/start`, logs decisions on `/end` |
| Work tracking | Linear, Jira, GitHub Issues | Reads active issues, updates status, creates new tickets |
| Team dashboard | Auto-generated | `team-current.md` regenerated every session |

You don't need all of these. Start with what your team already uses. You can add more later.

## Step 2: Create the Team Plugin

### Option A: Interactive (Recommended)

Run `/team init` and MARVIN walks you through each question:

1. Team name
2. Communication tool (Slack channel name, or skip)
3. Knowledge base tool (Google Doc IDs, Notion page IDs, Confluence space, or skip)
4. Work tracking tool (Jira projects, Linear team ID, GitHub repos, or skip)
5. Digest settings (where to post, approval required?)

MARVIN creates `.marvin-team/` with your answers filled in.

### Option B: Manual

Create the `.marvin-team/` directory in your workspace root. Copy from the template:

```bash
cp -r .marvin-team/_template/* .marvin-team/
```

Then edit `.marvin-team/team.yaml`. Here is the full configuration with every option commented and explained:

```yaml
# MARVIN Team Plugin Configuration
# Share this directory with your team.

team:
  name: "Platform Engineering"    # Your team name, shown in briefings

# --- Shared Context ---
# Configure where your team's shared context lives.
# Uncomment and fill in the tools your team uses.

shared_context:

  # Communication: where digests are posted and team activity monitored
  # slack:
  #   digest_channel: "#eng-marvin-updates"    # Channel for session digests
  #   monitor_channels:                         # Channels MARVIN reads for context
  #     - "#eng-general"
  #     - "#eng-blockers"

  # Knowledge base: where decisions and priorities live.
  # Pick one (or more):

  # google:
  #   priorities_doc_id: "1abc..."       # Google Doc ID for team priorities
  #   decisions_doc_id: "1def..."        # Google Doc ID for decision log
  #   team_state_doc_id: "1ghi..."       # Google Doc ID for shared team state

  # confluence:
  #   space: "ENG"                       # Confluence space key
  #   decisions_page_id: "12345"         # Page ID for decision log
  #   priorities_page_id: "12346"        # Page ID for priorities

  # notion:
  #   priorities_page_id: "abc-123"      # Notion page ID for priorities
  #   decisions_database_id: "def-456"   # Notion database ID for decisions

  # Work tracking: where tasks and projects are managed.
  # Pick one:

  # jira:
  #   projects:
  #     - key: "ENG"
  #       name: "Engineering"
  #     - key: "INFRA"
  #       name: "Infrastructure"

  # linear:
  #   team_id: "team_abc123"             # Your Linear team ID

  # github:
  #   repos:
  #     - "your-org/your-repo"
  #     - "your-org/another-repo"

# --- Behaviors ---
# What each MARVIN does with shared context at session boundaries.

behaviors:
  on_start:                          # Actions when you run /start
    - read_team_priorities           # Fetch priorities doc/page
    - read_recent_digests            # Check teammate digests since last session
    - check_team_blockers            # Surface active blockers

  on_end:                            # Actions when you run /end
    - post_digest                    # Draft and post session digest
    - update_decisions               # Update shared decisions if any made
    - update_blockers                # Update blockers if raised/resolved
    - regenerate_team_current        # Regenerate team-current.md dashboard

  digest:
    format: "digest/format.md"       # Digest template file
    post_to: "slack"                 # Where to post: "slack", "google",
                                     # "confluence", "notion"
    require_approval: true           # Ask before posting (recommended, default)

# --- Inngest Event Coordination (Optional, Level 2) ---
# Enable for push-based team awareness. Requires an Inngest account.
# Without this, team mode uses pull-based awareness (read on /start).

# inngest:
#   enabled: false
#   app_id: ""
#   events:
#     on_digest_posted: "marvin/digest.posted"
#     on_blocker_raised: "marvin/blocker.raised"
#     on_blocker_resolved: "marvin/blocker.resolved"
#     on_decision_made: "marvin/decision.made"
#   runtime: "inngest-cloud"         # or "ccr", "vercel", "cloudflare"
```

### Minimum Viable Configuration

You only need two things to start: a team name and one shared context tool. Everything else has sensible defaults.

```yaml
team:
  name: "My Team"

shared_context:
  slack:
    digest_channel: "#team-updates"

behaviors:
  on_start:
    - read_recent_digests
  on_end:
    - post_digest
  digest:
    post_to: "slack"
    require_approval: true
```

## Step 3: Define Roles (Optional)

Roles control what each team member's MARVIN prioritizes. They filter emphasis, not access. Every MARVIN sees the same shared data. A PM's MARVIN surfaces epics and timelines first. An engineer's MARVIN surfaces PRs and incidents first. Both can see everything.

### Built-in Presets

Three presets are included in `.marvin-team/roles/`:

**Engineer** (`roles/engineer.yaml`):
- Priorities: PRs awaiting review, assigned bugs, active incidents, deployment status
- Context: GitHub, Jira bugs, incident channels
- Digest emphasis: code shipped, PRs merged, bugs fixed, blockers hit

**Program Manager** (`roles/pm.yaml`):
- Priorities: Epic progress, cross-team dependencies, risks, timeline changes
- Context: Jira epics, project docs, stakeholder updates
- Digest emphasis: milestones hit, scope changes, dependency updates, risks flagged

**Engineering Manager** (`roles/em.yaml`):
- Priorities: Team velocity trends, active blockers, open headcount, process issues
- Context: Sprint metrics, blocker channels, team health signals
- Digest emphasis: team health, process changes, escalations, hiring updates

### Creating Custom Roles

1. Copy `roles/_template.yaml` to `roles/your-role.yaml`
2. Set the role name and description
3. Define `focus` fields for your tools (Jira filters, Slack channels, etc.)
4. Set `digest_emphasis` to describe what this role's digest should highlight
5. Share the updated `.marvin-team/` directory with your team

Example custom role for a DevOps engineer:

```yaml
role: "DevOps"
focus:
  jira_filters:
    - "project = INFRA AND status != Done"
    - "type = Incident AND resolution = Unresolved"
  slack_priority_channels:
    - "#incidents"
    - "#deployments"
    - "#on-call"
  digest_emphasis: "deployments, incidents, infra changes, on-call handoffs"
```

Any YAML file in `roles/` (except `_template.yaml`) becomes an available role when team members run `/team join`.

## Step 4: Test It

Before sharing with the team, verify the setup works end to end:

1. **Run `/start`** and confirm you see the TEAM section in your briefing. If no digests exist yet, MARVIN should note that and move on.
2. **Do some work.** Make a decision, raise a blocker, ship something.
3. **Run `/end`** and confirm the digest is drafted. Review the digest content. Approve it when prompted.
4. **Check the shared surface.** Open the Slack channel, Google Doc, Notion page, or Confluence page you configured. Confirm the digest appeared there.
5. **Run `/start` again.** You should now see your own digest in the team briefing (useful for verifying the round trip).

If any step fails, check the [Troubleshooting](#troubleshooting) section below.

## Step 5: Share With Your Team

Three ways to distribute the `.marvin-team/` directory:

### Git repo (recommended for dev teams)

Commit `.marvin-team/` to your shared workspace repo. Team members pull it down with the rest of the code. Add `my-role.yaml` to `.gitignore` so each person's role selection stays local.

```bash
echo ".marvin-team/my-role.yaml" >> .gitignore
git add .marvin-team/ .gitignore
git commit -m "feat: add MARVIN team plugin"
```

### File share (Slack, Drive, etc.)

Zip the `.marvin-team/` directory and share it. Team members unzip it into their MARVIN workspace root. Simple, but manual updates require re-sharing.

### Skills ecosystem

Publish the plugin via `npx skills` and team members install with `/skills`. Good for cross-org or open-source teams.

After distributing, tell your team to run `/team join` to select their role and activate team mode.

## Step 6: Ongoing Maintenance

- **Tool changes**: Update `team.yaml` when your team switches tools (new Slack channel, new Jira project, different Notion page). Share the updated directory.
- **Pulling updates**: Team members run `/team sync` to pull the latest `team.yaml` and role definitions.
- **Role changes**: Team members run `/team join` again to re-select their role.
- **Adding roles**: Create new YAML files in `roles/` and share the update.
- **Dashboard**: `team-current.md` is regenerated automatically on every `/end`. No manual maintenance needed.

## Troubleshooting

### "Tool not connected"

The tool is configured in `team.yaml` but MARVIN cannot reach it.

| Tool | What to check |
|------|---------------|
| Slack | Verify the Slack MCP server is installed and running. Confirm the channels exist and MARVIN has access. |
| Google Docs | Verify the `gws` CLI is installed and authenticated, or that the Google Workspace MCP is connected. Check that doc IDs are correct and accessible. |
| Confluence/Jira | Verify the Atlassian MCP server is connected. Check that space keys, project keys, and page IDs are correct. |
| Notion | Verify the Notion MCP server is connected. Check that page and database IDs are correct and shared with the integration. |
| Linear | Verify the Linear MCP server is connected. Check that the team ID is correct. |
| GitHub | Verify the `gh` CLI is installed and authenticated (`gh auth status`). Check that repo names match the format `org/repo`. |

### "Digest not posting"

1. Check the `post_to` field in `team.yaml`. It must match a configured tool (e.g., `"slack"` requires a `slack` section under `shared_context`).
2. Verify the tool is connected. Run `/team status` to check connectivity.
3. Confirm the digest destination exists (the Slack channel, Google Doc, Confluence page, or Notion page must already be created).
4. If `require_approval` is true (the default), make sure you are approving when prompted during `/end`.

### "Team section empty on /start"

This is normal when no digests have been posted yet. Once any team member completes an `/end` cycle and posts a digest, subsequent `/start` sessions will show team context.

If digests have been posted but still don't appear:

1. Verify you and your teammates are posting to the same destination (same Slack channel, same Google Doc ID, etc.).
2. Check that your `on_start` behaviors include `read_recent_digests`.
3. Run `/team status` to see recent team activity and verify tool connectivity.

### "Role not applied"

1. Check that `my-role.yaml` exists in `.marvin-team/`.
2. Verify the role name in `my-role.yaml` matches a file in `roles/` (case-sensitive).
3. Run `/team join` again to re-select your role.
4. Run `/start` and verify the role appears in your briefing header.
