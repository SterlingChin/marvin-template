---
name: guide-weekly-review
description: >
  Interactive guide to create a personalized weekly review skill that consolidates
  Obsidian daily notes, pulls Jira project status, generates a weekly summary,
  and creates a Monday focus block. Triggers on: "/guide weekly-review",
  "help me set up weekly review", "create my weekly review",
  "walk me through weekly planning".
---

# Setting Up Your Weekly Review

> **Reading this on GitHub?** Follow the steps below at your own pace.
> **Inside MARVIN?** Say `/guide weekly-review` and I'll walk you through it.

## Prerequisites

- MARVIN set up and running (complete [Guide 01](01-getting-started.md) first)
- Obsidian vault configured (complete [Guide 03](03-obsidian-vault.md) first)
- Jira access configured (set up during onboarding)
- Google Calendar access configured (optional, for focus block creation)

## What You'll Set Up

By the end of this guide you'll have:
- A personalized weekly review skill that reads your Obsidian daily notes
- Jira project pulse check integrated into your review
- A `/weekly-review` slash command
- Automated Monday focus block creation on your Google Calendar

## What is the Weekly Review?

Every week, the review:
1. **Reads your daily notes** from the past week (Monday-Friday)
2. **Extracts tagged items** — what you did (DONE), what's blocked, what's waiting, what you delegated
3. **Pulls Jira status** for your projects — on track, needs attention, or at risk
4. **Generates a weekly summary** saved to your Obsidian `Weekly/` folder
5. **Creates a focus block** on your Monday morning calendar with your top priorities

It's the difference between starting Monday with a clear plan vs. spending 30 minutes trying to remember what happened last week.

## Step 1: Check Prerequisites

Make sure your `config.yaml` already has:
- `obsidian_vault` path set (from Guide 03)
- `jira_projects` configured (from setup or Guide 04)

If not, MARVIN will help you set these now.

## Step 2: Configure Your Review

MARVIN will ask you:

### Jira Projects for Project Pulse
Which Jira projects should appear in your weekly status table? These are usually the same ones from your digest, but you might want to add or remove some.

### Focus Block Duration
How long should your Monday focus block be? Default: **2 hours**. This is protected time to work on your top priorities.

### Max Priority Items
How many items should appear in your focus block? Default: **8**. More than 8 and it stops being a focus list.

## Step 3: Generate the Skill

MARVIN reads the weekly-review blueprint, substitutes your config values, and writes:

- `skills/weekly-review/SKILL.md` — The main skill file
- `.claude/commands/weekly-review.md` — The `/weekly-review` slash command

## Step 4: Test Run

```
/weekly-review
```

MARVIN will read this week's daily notes, query Jira, and generate a weekly summary. Review the output:
- Are your daily notes being read correctly?
- Do the tag extractions look right?
- Is the Jira project pulse accurate?
- Does the carry-forward list make sense?

The summary is saved to your Obsidian `Weekly/` folder as `YYYY-WXX (MMM DD-DD).md`.

## Step 5: Weekly Rhythm

Run `/weekly-review` every Friday afternoon or Monday morning. The review:
- Looks at the most recent Monday-Friday by default
- Creates a focus block on the next Monday (if Google Calendar is connected)
- Saves the summary to your Obsidian Weekly/ folder with a backlink to the weekly index

## The Weekly Summary Structure

Here's what the generated summary looks like:

```markdown
# Week XX: Mar 24-28

## Summary
[2-3 sentence synthesis of the week's themes]

## Project Pulse
| Project | Status | Next Milestone | Notes |
|---------|--------|----------------|-------|
| NET | 🟢 | Q2 fabric rollout | 3 PRs merged, no blockers |
| NETOPS | 🟡 | Runbook audit | 2 items stalled >3 days |

## Accomplishments
- Shipped OSPF automation (NET-234)
- Completed CB3 pod-12 fabric cutover

## Carry Forward
- [ ] Review BGP cutsheet (NET-256)
- [ ] Follow up with Zayo on cross-connect

## Blocked
| Item | Blocker | Since |
|------|---------|-------|
| DEN1 spine layer | Zayo circuit not lit | Mar 20 |

## Delegated
| Item | Owner | Assigned |
|------|-------|----------|
| Fiber shuffle docs | @Chris | Mar 24 |
```

## What's Next

Run `/guide keeping-updated` to learn how to keep your skills current, or start using MARVIN with `/start`.

## Troubleshooting

**"No daily notes found"** — Check that your vault path in `config.yaml` is correct and that you have notes in the `Daily/` folder matching the `YYYY-MM-DD.md` format.

**Jira pulse shows "Unable to retrieve"** — Your Jira MCP may need re-authentication. Run `/status` to check.

**Focus block not created** — Google Calendar must be configured. If it's not set up yet, MARVIN will show the event details for you to create manually.

**Tags not being extracted** — Make sure tags are at the start of a line: `- DONE: ...` not `- I completed this (DONE)`.
