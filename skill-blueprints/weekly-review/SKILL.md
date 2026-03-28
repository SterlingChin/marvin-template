---
name: weekly-review
description: Weekly review and planning workflow for Obsidian daily notes. Use when user asks to "do my weekly review", "create weekly summary", "review this week", or "generate weekly report". Consolidates daily notes, extracts tagged items (DONE, BLOCKED, WAITING, DELEGATE, LONG TERM, ACTION), generates concise weekly summary with project pulse check, and creates Google Calendar focus block for next week's priorities.
license: MIT
compatibility: marvin
metadata:
  marvin-category: planning
  user-invocable: true
  slash-command: /weekly-review
  model: default
  proactive: false
---

# Weekly Review Skill

## Configuration

| Setting | Value |
|---------|-------|
| Obsidian Vault | `# From config.yaml: obsidian_vault` |
| Daily Notes | `# From config.yaml: daily_notes_dir` |
| Weekly Notes | `# From config.yaml: weekly_notes_dir` |
| Focus Duration | `# From config.yaml: weekly_review.focus_duration_hours` (default: 2) |
| Max Priority Items | `# From config.yaml: weekly_review.max_priority_items` (default: 8) |

### Jira Projects (for Project Pulse)
```yaml
# From config.yaml: jira_projects
# Example:
# jira_projects:
#   - PROJ1    # Project One
#   - PROJ2    # Project Two
#   - PROJ3    # Project Three
```

## Tag System

Parse these tags from daily notes to categorize items:

| Tag | Meaning | Action |
|-----|---------|--------|
| `DONE:` | Completed item | Move to accomplishments |
| `BLOCKED:` | Waiting on external party/person | Track in blockers with reason |
| `WAITING:` | Vendor/procurement dependency | Track in waiting table with lead time |
| `DELEGATE:` | Assigned to person/team | Track delegation status |
| `LONG TERM:` | Requires planning/epic | Flag for focus session, link to planning doc |
| `ACTION:` | New task identified | Add to priority actions |

Tags appear inline: `- DONE: Completed the automation script`
Include context: `- DELEGATE: @Chris documentation update`
Include lead times: `- WAITING: Hardware order (210 days, ordered Nov 15)`

## Process

### Step 0: Load Configuration

Read `config.yaml` and extract:
- `obsidian_vault` — path to Obsidian vault
- `daily_notes_dir` — subdirectory for daily notes (e.g., `Daily/`)
- `weekly_notes_dir` — subdirectory for weekly notes (e.g., `Weekly/`)
- `jira_projects` — list of Jira project keys
- `jira_base_url` — base URL for Jira ticket links
- `weekly_review.focus_duration_hours` — duration for focus block (default: 2)
- `weekly_review.max_priority_items` — max items in focus block (default: 8)

### Step 1: Establish Date Range
```bash
date +%Y-%m-%d
```
Default: Most recent Monday through Friday (or Sunday to Saturday if user prefers).

### Step 2: Gather Notes from Obsidian
- Read all daily notes from `{obsidian_vault}/{daily_notes_dir}/YYYY-MM-DD.md`
- Include all dates in range (skip missing days without error)
- Capture the full content for tag extraction

### Step 3: Extract & Categorize
Scan each daily note for:
- Tagged items (all tags from table above)
- Unchecked boxes `- [ ]` → carry forward
- Checked boxes `- [x]` → accomplishments
- Meeting outcomes and decisions
- Metrics and quantifiable progress
- Project references for pulse check

### Step 4: Pull Project Status from Jira

For each project in `config.yaml: jira_projects`, substituting project keys joined with commas:

1. **Query Jira** using the Atlassian MCP tools:
   - Get issues assigned to user in current sprint
   - Get blockers (issues with "Blocked" status or blocker-linked)
   - Get recent activity (issues updated this week)
   - Get sprint/milestone info

2. **Assess Status:**
   - :green_circle: **On track:** No blockers, active progress, sprint on pace
   - :yellow_circle: **Needs attention:** Some blockers, slowing velocity, or items requiring decisions
   - :red_circle: **At risk:** Critical blockers, stalled work, or sprint at risk

3. **Pull Next Milestone:** From Jira versions/epics

4. **Cross-reference tagged items:**
   - ACTION items → Search for related open tickets
   - DELEGATE items → Link to assignee's tickets
   - BLOCKED items → Find corresponding Jira blockers

### Step 5: Generate Weekly Summary

Create file: `{obsidian_vault}/{weekly_notes_dir}/YYYY-WXX (MMM DD-DD).md`

```markdown
# Week XX: [Date Range]
[[__Weekly]]

## Summary
[2-3 sentence synthesis of the week's major themes]

## Project Pulse
| Project | Status | Next Milestone | Notes |
|---------|--------|----------------|-------|
| [project name from config] | :green_circle:/:yellow_circle:/:red_circle: | [from Jira] | [blockers/highlights] |

Status: :green_circle: On track | :yellow_circle: Needs attention | :red_circle: At risk

## Accomplishments
[Bullet list grouped by category, max 10 items]

## Carry Forward
- [ ] [Priority items with context]

## Blocked
| Item | Blocker | Since | Jira |
|------|---------|-------|------|
| [item] | [who/what] | [date] | [link if exists] |

## Waiting (Vendor/Procurement)
| Item | Vendor | Lead Time | Order Date | ETA |
|------|--------|-----------|------------|-----|
| [item] | [vendor] | [days] | [date] | [date] |

## Delegated
| Item | Owner | Assigned | Status | Jira |
|------|-------|----------|--------|------|
| [item] | [person] | [date] | [status] | [link if exists] |

## Long Term Items
| Item | Planning Doc | Next Step |
|------|--------------|-----------|
| [item] | [[link]] | [schedule focus session / create epic] |

## Actions Captured
[New items to add - consider creating Jira tickets]

## Decisions Made
[Key decisions with context]

## Quick Reflection
- Win: [one thing that went well]
- Improve: [one thing to change]
```

### Step 6: Create Focus Block
Use Google Calendar to create event:
- **Calendar**: primary
- **When**: Monday morning, focus-duration-hour block before first meeting
- **Title**: "Weekly Focus Block"
- **Description**: Top priority items from carry forward (up to `config.yaml: weekly_review.max_priority_items`)

If Monday has no availability before noon, try Tuesday.

## Jira Integration Details

### Queries to Run

Substitute project keys from `config.yaml: jira_projects`, joining keys with commas:

```
# Issues assigned to user in active sprint
project in ({jira_project_keys}) AND assignee = currentUser() AND sprint in openSprints()

# Blockers in these projects
project in ({jira_project_keys}) AND (status = Blocked OR issueLinkType = Blocks)

# Recently updated by user
project in ({jira_project_keys}) AND updated >= -7d AND updatedBy = currentUser()
```

### Status Assessment Logic
- **:green_circle: On track:**
  - No blockers in user's assigned issues
  - At least one issue updated in past 3 days
  - Sprint burn rate on pace (if available)

- **:yellow_circle: Needs attention:**
  - 1-2 blockers present
  - No updates in 3+ days
  - Sprint at 50%+ complete with significant backlog

- **:red_circle: At risk:**
  - 3+ blockers
  - Critical priority items stalled
  - Sprint behind schedule by >20%

## Error Handling

- No daily notes found → Confirm date range with user
- Weekly directory missing → Create it
- Jira unavailable → Output pulse section as "Status: Unable to retrieve - check Jira access"
- Calendar unavailable → Output event details for manual creation
- No morning availability → Suggest alternative slot

---

*Blueprint created from weekly-review skill*
