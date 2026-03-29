---
description: End MARVIN session - save context, update logs and state
---

# /end - End MARVIN Session

Wrap up the current session and save all context for continuity.

**The goal:** A fresh session tomorrow should read ONLY `state/current.md` and know exactly where things stand. Every `/end` must leave that file accurate and complete.

## Instructions

### 1. Summarize This Session
Review the conversation and extract:
- **Topics discussed** - What did we work on?
- **Decisions made** - What was decided and why?
- **Content shipped** - Any content published, drafted, or completed?
- **Open threads** - What's unfinished or needs follow-up?
- **Action items** - What needs to happen next?

### 2. Update Session Log
Get today's date with `date +%Y-%m-%d`.

Append to `sessions/{TODAY}.md` (create if it doesn't exist):
```markdown
## Session End: {TIME}

### Topics
- {topic 1}
- {topic 2}

### Decisions
- {decision and reasoning}

### Content Shipped
- {content item, or "None"}

### Open Threads
- {thread 1}

### Next Actions
- {action 1}
```

If creating a new file, add header: `# Session Log: {TODAY}`

### 3. Log Decisions
If any decisions were made during this session, append each to `state/decisions.md`:
```markdown
### {TODAY} - {Decision Title}
**Decision:** {What was decided}
**Context:** {Why this decision was made}
**Status:** Active
```

Create the file with header `# Decision Log` if it doesn't exist.

### 4. Log Content Shipped
If any content was shipped (published, posted, completed drafts), append to `content/log.md`:
```markdown
| {TODAY} | {Type} | {Title/Description} | {Where published/saved} |
```

Create the file with this header if it doesn't exist:
```markdown
# Content Log

| Date | Type | Title | Destination |
|------|------|-------|-------------|
```

### 5. Update State (MANDATORY)
This is the most important step. Check the "Last updated" date in `state/current.md`:

**If 3+ days stale (or no timestamp):** Do a full rewrite.
- Re-read the last 3 days of session logs
- Rebuild priorities, open threads, and project statuses from scratch
- Ensure nothing is carried forward that's already resolved

**If recent (updated within 3 days):** Do an incremental update.
- Mark completed items as done or remove them
- Add new priorities and open threads
- Update project statuses
- Update the "Recent Context" section with the last 5 session entries
- Shift priorities based on what emerged this session

**Always:**
- Update the "Last updated: {TODAY}" line
- Ensure open threads reflect reality (remove resolved, add new)
- Ensure priorities are ordered by actual urgency

### 5.5. Team Digest

Check if `.marvin-team/team.yaml` exists. If it does, team mode is active.

Invoke the `team-awareness` skill to draft and post a team digest:

1. Read `.marvin-team/_template/digest/format.md` for the format template (or `.marvin-team/digest/format.md` if it exists in the working plugin)
2. From this session, extract: shipped items, in-progress work, decisions made, blockers raised or resolved
3. Draft the digest using the format template
4. Read the user's name from the User Profile section of `CLAUDE.md`
5. Present the draft and ask for approval:

```
Team digest for [configured destination]:

## **[Name] — [Date]**

**Shipped:**
- {items}

**In Progress:**
- {items}

**Decisions:**
- {items}

**Blockers:**
- {items}

Post to [destination]? (y/n)
```

6. **CRITICAL: Never auto-post. Always wait for explicit approval.**
7. If approved: post using the tool configured in `behaviors.digest.post_to`
8. If declined: note "Team digest skipped" in the session log

If decisions were made, also update the shared decisions doc/page.
If blockers were raised or resolved, update the shared blockers.

If `.marvin-team/team.yaml` does not exist, skip this step entirely.

### 6. Confirm
Show a brief summary:
- What was logged
- Key items for next session
- State update confirmation (incremental or full refresh)
- Team digest: posted to [destination] / skipped / team mode not active

Keep it concise.
