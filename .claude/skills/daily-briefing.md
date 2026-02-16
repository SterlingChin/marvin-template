---
name: daily-briefing
description: Generate daily briefing with priorities, progress, and alerts. Used by /marvin or when user asks "what's on today"
---

# Daily Briefing

Generate a comprehensive daily briefing with priorities, progress tracking, and proactive alerts.

## When to Use

Claude Code should invoke this skill when:
- The `/marvin` command runs (as part of session start)
- User asks "what's on today" or "daily briefing"
- User requests a morning check-in

## How It Works

### Step 1: Calendar Overview (if available)
- Today's events with times
- Tomorrow's events (preview)
- Next 7 days: any important deadlines

### Step 2: Task Status
From `state/current.md`:
- Active priorities
- Overdue items
- Due today
- Open threads needing attention

### Step 3: Progress Check
For current month from `state/goals.md`:
- Progress against each goal
- Days remaining in month

If behind pace, flag it.

### Step 4: Open Threads
From `state/current.md`:
- Anything waiting on follow-up
- Stale threads (no update > 5 days)

### Step 5: Proactive Suggestions
Based on patterns:
- "You haven't made progress on {goal} this week"
- "Deadline for {item} is in 3 days"
- "Monthly review coming up, want to schedule?"

## Output Format

Keep concise. Structure as:

```
## {Day}, {Date}

**Today**: {summary}

**Alerts**:
- {any urgent items}

**Progress**: {goal status summary}

**Focus**: {top 1-2 priorities}
```

Offer to expand any section on request.

## Notes

- This skill supports the `/marvin` command but can also run standalone
- Keep the briefing concise. Details on request.
- If resuming a session (today's log exists), acknowledge what was already covered
