---
name: team-digest
description: |
  Generate a daily team digest by querying Jira, Slack, and GitHub,
  then synthesizing activity into an actionable engineering briefing posted to Slack.
license: MIT
compatibility: marvin
metadata:
  marvin-category: work
  user-invocable: true
  slash-command: /team-digest
  model: default
  proactive: false
---

# Team Digest

Generate and post the daily team digest — a TPM-style synthesis of Jira, Slack, and GitHub activity into actionable engineering intelligence.

## When to Use

- User types `/team-digest`
- User asks to "generate the digest", "run the digest", or "post the daily update"
- Morning briefing time and user wants the team digest

## Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| Jira projects | `# From config.yaml: jira_projects` | Team's tracked projects |
| Slack channels (read) | `# From config.yaml: slack_channels_monitor` | Monitor these for activity |
| Slack channel (post) | `# From config.yaml: slack_channel_post` | Where to post the digest |
| GitHub repos | `# From config.yaml: github_repos` | Repos to monitor for PRs/releases |
| Jira base URL | `# From config.yaml: jira_base_url` | For ticket links |
| Lookback window | `# From config.yaml: digest.lookback_hours` (default: 24) | From current time |

## Process

### Step 0: Load Configuration

Read `config.yaml` and extract:
- `jira_projects` — list of Jira project keys
- `jira_base_url` — base URL for Jira ticket links
- `slack_channels_monitor` — list of Slack channels to read
- `slack_channel_post` — Slack channel to post the digest to
- `github_repos` — list of GitHub repos (org/repo format)
- `digest.workstreams` — list of workstream names for grouping
- `digest.lookback_hours` — how far back to look (default: 24)

### Step 1: Load Context

Read the TPM system prompt and agent instructions:

```
skills/team-digest/prompts/system_prompt.md
skills/team-digest/prompts/agent_instructions.md
```

Internalize the TPM methodology, risk signals, workstream definitions, and digest format. These define how you analyze data and write the output. Everything that follows should be guided by those prompts.

### Step 2: Gather Jira Activity

Query Jira using the Atlassian MCP tools. Run these JQL queries, substituting project keys from `config.yaml: jira_projects` (join keys with commas):

**Active epics with progress:**
```
project in ({jira_project_keys}) AND issuetype = Epic AND status != Done ORDER BY updated DESC
```

For each active epic, get child issues to calculate completion (done/total).

**Recently updated issues (within lookback window):**
```
project in ({jira_project_keys}) AND updated >= -1d ORDER BY updated DESC
```

**Blocked issues:**
```
project in ({jira_project_keys}) AND status = Blocked ORDER BY priority DESC
```

For each issue, capture: key, summary, status, assignee, priority, parent epic (if any), labels.

### Step 3: Gather Slack Activity

Read the last N hours (from `config.yaml: digest.lookback_hours`) from each channel listed in `config.yaml: slack_channels_monitor` using the Slack MCP tools.

For each channel, capture messages and thread replies. Look for:
- Decisions made
- Blockers raised
- Incidents discussed
- External dependency mentions (carriers, vendors, providers)
- Work discussed but not tracked in Jira (shadow work)

### Step 4: Gather GitHub Activity

Use `gh` CLI to query activity within the lookback window for each repo in `config.yaml: github_repos`:

```bash
# PRs opened, merged, or closed
gh pr list --repo {org/repo} --state all --json number,title,state,author,mergedAt,createdAt,closedAt,labels,url --limit 50

# Recent releases
gh release list --repo {org/repo} --limit 5 --json tagName,name,publishedAt,url
```

Filter results to the lookback window. Cross-reference PR titles/descriptions with Jira ticket IDs.

### Step 5: Analyze and Synthesize

Following the TPM methodology from the system prompt:

1. **Cross-reference and deduplicate** — A PR that closes a Jira ticket discussed in Slack is one story, not three.
2. **Group by workstream** — Use workstream names from `config.yaml: digest.workstreams`.
3. **Prioritize by impact** — Blockers and risks first, routine progress as context.
4. **Flag gaps** — Shadow work, stalled tickets, untracked PRs, stale statuses.
5. **Watch for risk signals** — Change management gaps, dependency delays, drift from design, deployment risks, coverage gaps.

### Step 6: Generate Digest and Changelog

Generate two outputs following the format in `agent_instructions.md`:

**Changelog (main Slack message):**
- 2-3 themes combining related activity across all sources
- Terse, scannable, no narrative framing

**Digest (thread reply):**
- Organized by workstream headers (from `config.yaml: digest.workstreams`)
- Active epics with completion % and what moved
- Every ticket/PR linked
- Blockers called out explicitly
- Under 3000 characters

### Step 7: Review Before Posting

Present both the changelog and digest to the user for review. Ask:
- "Ready to post to `#{slack_channel_post}`?" (channel name from `config.yaml: slack_channel_post`)
- Note any data gaps (e.g., "Slack returned no messages from #channel — channel may be quiet or permissions issue")

Do NOT post until the user confirms.

### Step 8: Post to Slack

Once approved, post using the Slack MCP tools:

1. **Post the changelog** as the main message to the channel from `config.yaml: slack_channel_post`
2. **Post the digest** as a thread reply to that message

## Output Format

See `skills/team-digest/prompts/agent_instructions.md` for the exact digest and changelog format specifications.

## Notes

- **Prompt changes:** Edit files in `skills/team-digest/prompts/` to tune the TPM methodology, risk signals, or output format.
- **Workstream customization:** Update `config.yaml: digest.workstreams` to match your team's organizational structure. The workstream names flow through to section headers in the digest output.
- **Channel permissions:** Ensure the Slack integration has read access to all monitored channels and write access to the post channel.

---

*Blueprint created from tq-digest skill*
