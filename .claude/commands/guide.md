---
description: Interactive setup guides for MARVIN capabilities
---

# /guide - Setup Guides

Walk through setup guides interactively or list what's available.

## Instructions

### Usage
- `/guide` — List all available guides with completion status
- `/guide {name}` — Start a specific guide (e.g., `/guide obsidian`)

### Step 1: Load Config

Read `config.yaml` to check `guides_completed` list.
Read `.marvin-source` to get the template path where guides live.

### Step 2: List or Launch

**If no argument:** Read `{template_path}/guides/README.md` and display
the guide catalog with completion markers from config.yaml:
- [x] completed guides
- [ ] pending guides

**If argument provided:** Find matching guide in `{template_path}/guides/`
(match on filename slug or guide name — e.g., "obsidian" matches `03-obsidian-vault.md`,
"getting-started" matches `01-getting-started.md`). Read the guide file and
follow it interactively, step by step.

### Step 3: Interactive Walkthrough

When running a guide:
- Present one step at a time
- Ask for user input at decision points
- Execute commands on the user's behalf (with confirmation for anything destructive)
- Update `config.yaml` as values are collected
- Mark guide as completed when done by adding its slug to `guides_completed` in config.yaml

### Step 4: Next Guide

After completing a guide, suggest the next uncompleted guide in sequence:
> "Guide complete! Next up: {next guide name}. Run `/guide {slug}` when you're ready, or `/guide` to see the full list."

### Step 5: Re-running a Completed Guide

If the user runs a guide that's already in `guides_completed`:
> "You've already completed this guide. Would you like to run it again to reconfigure?"

If yes, proceed normally. If no, show the guide list.
