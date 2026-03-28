---
name: guide-team-digest
description: >
  Interactive guide to create a personalized team digest skill that queries
  Jira, Slack, and GitHub and posts a daily synthesis to Slack. Triggers on:
  "/guide team-digest", "help me set up the digest", "create my team digest",
  "walk me through the digest skill".
---

# Creating Your Team Digest

> **Reading this on GitHub?** Follow the steps below at your own pace.
> **Inside MARVIN?** Say `/guide team-digest` and I'll walk you through it.

## Prerequisites

- MARVIN set up and running (complete [Guide 01](01-getting-started.md) first)
- Jira access configured (set up during onboarding)
- Slack access configured (set up during onboarding)
- GitHub CLI (`gh`) installed and authenticated

## What You'll Set Up

By the end of this guide you'll have:
- A personalized team digest skill that queries YOUR Jira boards, Slack channels, and GitHub repos
- A `/team-digest` slash command to generate and post the digest
- A daily engineering intelligence report posted to your team's Slack channel

## What is the Team Digest?

The team digest is a TPM-style daily briefing that:
1. **Queries Jira** for active epics, recently updated issues, and blockers
2. **Reads Slack** for decisions, discussions, and shadow work
3. **Checks GitHub** for PRs merged, opened, and releases
4. **Synthesizes** everything into a concise, actionable update organized by workstream
5. **Posts to Slack** as a changelog (main message) + detailed digest (thread reply)

It's like having a technical program manager who reads everything and writes you a morning brief.

## Step 1: Configure Your Sources

MARVIN will ask you these questions interactively. If you're reading this on GitHub, think about your answers:

### Jira Projects
What Jira project keys should the digest track? These are the short prefixes on your tickets (e.g., `NET-123` means the project key is `NET`).

You can find your project keys at: https://fluidstack.atlassian.net/jira/projects

### Slack Channels
Which Slack channels should the digest monitor for activity? Pick channels where your team discusses work, raises blockers, and makes decisions.

Also: which channel should the digest POST to? This is where your team will see the daily update.

### GitHub Repos
Which GitHub repos should the digest watch for PRs and releases? Use the `org/repo` format (e.g., `fluidstackio/net-tools`).

### Workstreams
How is your team's work organized? The digest groups updates by workstream. Your role profile has defaults, but you can customize:

- **Infrastructure Engineers:** Engineering Core, Deployment & Integration, Operations & Reliability, Corporate & Enterprise
- **Program Managers:** Program Milestones, Cross-Team Dependencies, Risk & Escalation, Delivery Tracking
- **ICT Architects:** Architecture & Design, Standards & Compliance, Technology Evaluation, Integration Patterns

## Step 2: Generate the Skill

MARVIN reads the skill blueprint from the template, substitutes your configuration values, and writes the personalized skill to your workspace:

- `skills/team-digest/SKILL.md` — The main skill file
- `skills/team-digest/prompts/system_prompt.md` — TPM methodology and analysis rules
- `skills/team-digest/prompts/agent_instructions.md` — Output format specification
- `.claude/commands/team-digest.md` — The `/team-digest` slash command

## Step 3: Test Run

Run your first digest in review mode:

```
/team-digest
```

MARVIN will query all your sources, synthesize the data, and show you the output WITHOUT posting to Slack. Review it:
- Are the right Jira projects showing up?
- Are Slack channels being read correctly?
- Are GitHub PRs cross-referenced with Jira tickets?
- Do the workstream groupings make sense?

## Step 4: Go Live

Once you're happy with the output, tell MARVIN to post it. The digest posts as:
1. A **changelog** (main Slack message) — 2-3 themes with status emojis, scannable at a glance
2. A **detailed digest** (thread reply) — organized by workstream, every ticket and PR linked

The digest always asks for your approval before posting. It will never auto-post.

## Step 5: Daily Use

Run `/team-digest` each morning (or whenever you want a team update). Over time you can:
- Adjust your workstreams in `config.yaml`
- Add or remove Slack channels
- Add more GitHub repos
- Edit `skills/team-digest/prompts/system_prompt.md` to tune the analysis

## What's Next

Run `/guide weekly-review` to set up weekly planning, or `/guide keeping-updated` to learn about skill updates.

## Troubleshooting

**"No Slack messages found"** — Check that MARVIN has access to the channels. Some channels may be private — you may need to invite the Slack app.

**Jira returns no results** — Verify your Jira project keys are correct. Try running a manual search in Jira to confirm.

**GitHub shows no PRs** — Make sure `gh` is authenticated: `gh auth status`. The digest uses the `gh` CLI, not MCP.

**Digest is too long/short** — Edit `skills/team-digest/prompts/agent_instructions.md` to adjust the character limit and level of detail.
