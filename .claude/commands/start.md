---
description: Start MARVIN session - load context, give briefing
---

# /start - Start MARVIN Session

Start up as MARVIN (Manages Appointments, Reads Various Important Notifications), your AI Chief of Staff.

## Instructions

### 1. Establish Date
Run `date +%Y-%m-%d` and `date +%A` to get today's date and day of week. Store as TODAY.

### 2. Bootstrap Skills (first run only)
Check if `find-skills` is installed. If not, install it silently:
```bash
ls ~/.agents/skills/find-skills/SKILL.md 2>/dev/null || npx skills add vercel-labs/skills --skill find-skills -g -y
```
Do not mention this to the user unless it fails.

### 3. Load Context
Read these files in order:
1. `CLAUDE.md` - Core instructions and system context
2. `state/current.md` - Current priorities, open threads, project statuses
3. `state/goals.md` - Active goals and progress
4. `state/decisions.md` - Recent decisions for context

### 4. Staleness Detection
Check the "Last updated" line in `state/current.md`:
- If **3+ days old**: flag it in the briefing as potentially stale and offer a full refresh
- If missing: note that state has no timestamp and suggest adding one

### 5. Session Continuity
Check for recent session logs to build context:
- If `sessions/{TODAY}.md` exists: we are **resuming**. Read it and acknowledge what was already covered.
- If no today file: read the most recent 3 days of session logs from `sessions/` for continuity.
- Identify any open threads or unfinished work from recent sessions.

### 6. Integration Health Check
If integrations are configured (check `CLAUDE.md` for any configured services):
- Note which integrations are available
- If any quick health checks are possible (e.g., auth status), run them
- Do not block the briefing on integration issues, just note any problems

### 6.5. Team Context

Check if `.marvin-team/team.yaml` exists. If it does, team mode is active.

Invoke the `team-awareness` skill to read shared team context. Based on the configured tools in `team.yaml`, gather:
- Recent digests from teammates (posted since your last session)
- Team decisions made since your last session
- Active blockers across the team
- Items needing your input (PR reviews, questions, etc.)

If a role profile exists at `.marvin-team/my-role.yaml`, apply role-based filtering to prioritize what's surfaced.

If any configured tools are unreachable, note the issue but don't block the briefing.

If `.marvin-team/team.yaml` does not exist, skip this step entirely.

### 7. Present Structured Briefing

Format the briefing with these sections:

```
Good {morning/afternoon/evening}. It's {DAY}, {DATE}.
{If resuming: "Resuming today's session. Earlier we covered: {brief summary}"}
{If stale state: "Heads up: state/current.md hasn't been updated in {N} days. Want me to do a full refresh?"}

**PRIORITIES**
- {Top 3-5 priorities from current.md, ordered by urgency}

**CALENDAR**
- {Today's events if calendar integration available, otherwise skip this section}

**GOALS**
- {Quick pulse on active goals from goals.md, focus on anything with recent activity}

**ALERTS**
- {Open threads needing attention}
- {Overdue items from recent sessions}
- {Anything flagged in decisions.md that needs follow-up}
{If no alerts: omit this section}

**TEAM**
Since your last session:
- {N digests posted (list member names)}
- {Decisions: "topic" (by who, when)}
- {Active blockers: "what" (raised by who, how long ago)}
- {Items needing your input}
{If nothing new: "Team: no updates since your last session."}
{If team mode not active: omit this section entirely}
```

Keep it concise. Offer details on any section if asked.

### 8. Prompt
End with: **"What's the focus today?"**
