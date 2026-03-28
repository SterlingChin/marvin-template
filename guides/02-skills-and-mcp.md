---
name: guide-skills-and-mcp
description: >
  Interactive guide to install the Codex marketplace plugin, understand the
  skills ecosystem, and verify MCP integrations. Triggers on: "/guide skills-and-mcp",
  "help me set up skills", "install codex", "what are MCP servers".
---

# Skills & MCP Setup

> **Reading this on GitHub?** Follow the steps below at your own pace.
> **Inside MARVIN?** Say `/guide skills-and-mcp` and I'll walk you through it.

## Prerequisites

- MARVIN set up and running (complete [Guide 01](01-getting-started.md) first)
- GitHub access to `fluidstackio/codex`

## What You'll Set Up

By the end of this guide you'll have:
- The Fluidstack Codex skill marketplace installed
- Company-wide skills available (NRFC writer, RFC crafter, PRD crafter, etc.)
- An understanding of how skills, plugins, and MCP servers fit together

## Concepts: What Are Skills and MCP?

**Skills** are capabilities that extend what MARVIN (Claude Code) can do. Think of them like plugins:
- **Codex skills** are shared across the company (e.g., writing NRFCs, PRDs). They come from the `fluidstackio/codex` repo.
- **MARVIN skills** are personal to your workspace (e.g., your team digest, weekly review). They live in your `skills/` directory.

**MCP (Model Context Protocol) servers** are how MARVIN connects to external tools — Jira, Slack, Google Calendar, etc. They were set up during onboarding. Skills USE MCP servers to do their work (e.g., the team digest skill uses the Jira MCP to query tickets).

## Step 1: Add the Codex Marketplace

Run this in your terminal (not inside MARVIN):

```bash
claude plugin marketplace add fluidstackio/codex
```

This registers the Fluidstack Codex as a skill source. It pulls from the private `fluidstackio/codex` repo using your GitHub credentials.

## Step 2: Install Skills

Install the document skills plugin (includes NRFC writer, RFC crafter, PRD crafter, and markdown formatter):

```bash
claude plugin install codex-document-skills
```

## Step 3: Verify Installation

Check that everything installed:

```bash
claude plugin list
```

You should see `codex-document-skills` in the list with its skills.

## Step 4: Test a Skill

Start MARVIN and try the NRFC writer:

```bash
marvin
```

Then inside MARVIN:
```
/nrfc-writer
```

MARVIN should start an interactive NRFC writing session. You can exit by saying "cancel" or just test that it responds.

## Step 5: Understand the Landscape

Here's how the different skill types relate:

| Type | Where They Live | How to Get Them | Examples |
|------|----------------|-----------------|----------|
| **Codex plugins** | `fluidstackio/codex` repo | `claude plugin install` | NRFC writer, RFC crafter, PRD crafter |
| **MARVIN skills** | Your workspace `skills/` dir | `/guide` walkthroughs or manual creation | Team digest, weekly review |
| **MCP integrations** | Claude Code config | Onboarding or `claude mcp add` | Jira, Slack, Google Calendar |

**Codex skills** update independently. You'll learn how to keep them updated in [Guide 06](06-keeping-updated.md).

## Step 6: Check MCP Health

Inside MARVIN, you can check which integrations are connected:

```
/status
```

Or from the terminal:
```bash
claude mcp list
```

This shows all configured MCP servers (Jira, Slack, Google, etc.) and their status.

## What's Next

Run `/guide obsidian` to set up your second brain, or `/guide team-digest` to create your daily team digest.

## Troubleshooting

**"marketplace add" fails with auth error** — Your GitHub credentials may not have access to `fluidstackio/codex`. Verify with: `gh repo view fluidstackio/codex`

**"/nrfc-writer" doesn't appear** — Restart MARVIN after installing plugins. Skills load on startup.

**"plugin not found"** — Run `claude plugin marketplace update` to refresh the marketplace catalog, then try `claude plugin install` again.
