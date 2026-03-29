# Team Digest Format

When posting a team digest, use this format:

## **[Member Name] — [Date]**

**Shipped:**
- {completed items with ticket/PR references}

**In Progress:**
- {active work items}

**Decisions:**
- {any decisions made, with brief rationale}

**Blockers:**
- {anything blocking progress, who/what is needed to unblock}

---

### File Naming
Digest files use the format: `YYYY-MM-DD-firstname-lastname.md`
Examples: `2026-03-28-alex-chen.md`, `2026-03-28-casey-kim.md`

The name is derived from the User Profile in CLAUDE.md. Use lowercase, hyphens for spaces.

### Definitions
- **Shipped** means deployed to production or fully complete. Not "merged to main" or "PR approved."
- **In Progress** includes work that's merged but not yet validated (e.g., "merged, integration tests pending").
- If something ships mid-day but you already wrote your digest, update it or note the timing in Notes.

### Timing
Digests reflect what you know at the time of writing. If team context changes after you post (e.g., a teammate ships something that changes a milestone count), that's normal. The next day's digests will reflect the updated state.

When reading digests, check the **date and order**. Later digests on the same day may have more current information than earlier ones.

### Guidelines
- Keep each section to 2-4 bullet points max
- Reference ticket IDs, PR numbers, or doc links where possible
- Skip empty sections (no blockers? omit the section)
- Write for teammates who are scanning, not reading deeply
- Be specific: "Shipped ACME-156 (API rate limiting)" not "Made progress on API work"
