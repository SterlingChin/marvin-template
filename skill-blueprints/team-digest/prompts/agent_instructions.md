# Team Digest — Output Format Instructions

## Digest Format

Generate a daily team digest. The audience is engineers — write like a senior engineer briefing peers. No PM-speak, no narrative framing, no filler adjectives. Say what happened, not what it means.

Bad: "Infrastructure Reaches Operational Milestone"
Good: "`env-12` deployment complete, services healthy on all nodes"
Bad: "A comprehensive deployment initiative was advanced"
Good: "3 tasks completed at `site-A`, 2 pending external handoff (PROJ-183)"
Bad: "Expansion progressing well"
Good: "`site-B` rollout deployed, auth live on all endpoints (PROJ-45)"

Use standard markdown formatting (headers #, bold **, links [text](url), etc.). The output will be automatically converted for Slack.

Status emojis: use these as line prefixes so engineers can triage visually:
- :large_green_circle: shipped / no action needed
- :warning: at risk / needs awareness
- :red_circle: blocked

### Guidelines

- Organize by workstream: Use workstream names from `config.yaml: digest.workstreams`
- Lead with active epics — for each active epic, report completion %% (done/total children) and what moved
- Link every Jira ticket/epic using the Jira base URL from `config.yaml: jira_base_url` (e.g. [PROJ-123]({jira_base_url}/PROJ-123))
- Cross-reference GitHub PRs with Jira tickets
- Reference identifiers, hostnames, and site codes alongside ticket numbers
- Highlight active and upcoming change windows / maintenance schedules
- Flag vendor/external dependencies explicitly — name the provider, state duration, note SLA impact
- Use backticks liberally: system names, interface names, identifiers, config values, CLI commands
- Be terse — one bullet, one fact. No filler sentences.
- Blockers called out explicitly — not buried mid-paragraph. State what's stuck, who's waiting on what, and how long.
- Keep under 3000 characters

### Structure

Structure the report by workstream. Use the following visual format for section headers to make transitions between workstreams easy to scan:

```
━━━━━━━━━━━━━━━
*|||  Workstream Name  |||*
━━━━━━━━━━━━━━━
updates here


━━━━━━━━━━━━━━━
*|||  Another Workstream  |||*
━━━━━━━━━━━━━━━
updates here
```

Each workstream header is a 3-line block: a divider line of 15 `━` characters, then the section name wrapped in `*|||  Name  |||*` (bold in Slack mrkdwn with `|||` delimiters and 2 spaces of padding), then another divider line of 15 `━` characters. Leave TWO blank lines between the end of one section's content and the start of the next section's divider block. The first section should also have this header block.

Within each workstream, list active epics using this format:

- **[EPIC-KEY: Epic Summary](epic-url)** (X/Y done) — due YYYY-MM-DD / no due date
  - One bullet per meaningful update today (ticket transitions, PRs merged, deployments completed, configs pushed). Keep each bullet to one line.

## Changelog Format

Also generate a changelog summarizing the last 24 hours into 2-3 themes. Combine related activity across Jira, GitHub, and Slack. Write for engineers — no narrative framing or PM adjectives.

Do NOT include a TL;DR summary line at the top. Jump straight into the themes. Do NOT include a title or header above the themes.

Format:
- Status emoji **Terse theme title**
  1-2 sentences. State what happened. Use backticks for system names, identifiers, interface names, site codes, and config values. Reference tickets and PRs.

Keep it concise — scannable, not readable.

## Posting

The changelog is the main Slack message. The digest goes as a thread reply to that message.
