# MARVIN Teams

Turn your team's individual MARVIN instances into a coordinated team operating system. No servers, no new infrastructure. Just shared context through tools you already use.

## What Is This?

Every person on your team runs their own MARVIN. Each instance knows everything about that person's work: what they shipped, what decisions they made, what's blocking them. But each instance is also an island. Your MARVIN has no idea what your teammates are doing.

MARVIN Teams connects those islands. When you finish a session, your MARVIN drafts a short digest of what happened and posts it to a shared surface (a Slack channel, a Notion page, a Confluence space, whatever your team already uses). When your teammate starts their next session, their MARVIN reads your digest and folds it into their briefing.

The result is a team standup that happens passively. Nobody writes status updates. Nobody fills out a form. Each MARVIN already knows what its person did. Teams just lets them share that knowledge.

## How It Works

```
You run /end                          Teammate runs /start
     |                                        |
     v                                        v
MARVIN drafts digest                  MARVIN reads shared surface
     |                                        |
     v                                        v
You approve it                        Sees your digest + others
     |                                        |
     v                                        v
Posted to shared surface              Includes in team briefing
(Slack, Notion, Confluence, etc.)     (priorities, blockers, wins)
```

There is no direct communication between MARVIN instances. Everything flows through your team's existing tools, which act as the shared context layer. Each MARVIN reads on startup and writes on shutdown. Pull-based, simple, no infrastructure to maintain.

The cycle works like this:

1. You do your work with MARVIN as usual.
2. At `/end`, MARVIN summarizes your session into a digest: what you shipped, decisions made, blockers raised.
3. You review the digest and approve it. MARVIN posts it to the shared surface.
4. When a teammate starts their next session, their MARVIN pulls recent digests and surfaces relevant context: your blocker that affects their project, the decision that changes their priorities, the feature you shipped that unblocks their work.

A `team-current.md` file is regenerated every time any team member runs `/end`. It's a human-readable dashboard you can open anytime to get a 30-second read on where the team stands.

## Supported Tools

| Category | Supported Tools |
|----------|-----------------|
| Communication | Slack, Notion, Confluence, Obsidian |
| Knowledge Base | Notion, Confluence, Google Docs, Obsidian |
| Work Tracking | Linear, Jira, GitHub Issues |

Mix and match. Use what your team already has. You only need one shared surface to get started.

## Getting Started

### For Team Leads

1. **Run `/team init`** inside MARVIN. It walks you through choosing your tools and configuring the plugin.
2. **Test the round trip.** Run `/end` to post a digest, then `/start` to verify it appears in the team briefing.
3. **Share `.marvin-team/`** with your team via git, file share, or the skills ecosystem.

Full setup instructions: [Leader Setup Guide](team-setup-leader.md)

### For Team Members

1. **Get the `.marvin-team/` directory** from your team lead (git pull, download, etc.).
2. **Run `/team join`** inside MARVIN. Pick your role when prompted.
3. **Run `/start`** to see your team briefing. You're set.

## Roles

Roles prioritize, they don't restrict. Every MARVIN on the team sees the same shared data. A role changes what gets surfaced first in your briefing and what your digest emphasizes.

### Built-in Presets

| Role | Surfaces First | Digest Emphasizes |
|------|---------------|-------------------|
| Engineer | PRs, bugs, incidents, deployments | Code shipped, bugs fixed, blockers hit |
| Program Manager | Epics, dependencies, risks, timelines | Milestones, scope changes, risks flagged |
| Engineering Manager | Velocity, blockers, headcount, process | Team health, escalations, process changes |

### Custom Roles

Copy `roles/_template.yaml`, define what your role prioritizes, and drop it into `.marvin-team/roles/`. Any YAML file in that directory becomes an available role.

A custom role for a DevOps engineer might prioritize incident channels and deployment status. A role for a tech lead might prioritize architecture decisions and code review queues. Define whatever fits.

### No Role? That's Fine.

Roles are optional. A team of five engineers with no roles assigned still benefits from shared digests and the team dashboard. Roles add focus when you need it.

## The Team Dashboard

`team-current.md` is a file regenerated automatically every time any team member's MARVIN runs `/end`. Open it when you want a quick answer to "what's happening with my team?" without reading individual digests.

It includes:

- Active projects with milestone progress
- Who's working on what (one line per person)
- Active blockers
- Recent decisions (last 7 days)
- This week's wins

Example:

```markdown
# Team Current -- Platform Engineering
*Last updated: 2026-03-28 by Alex (Engineer)*

## Active Projects
- **Auth v2 migration** -- 70% complete, on track for April 4
- **API rate limiting** -- spec approved, implementation starting

## Who's Working on What
- Alex: Auth v2 migration (token refresh flow)
- Jordan: API rate limiting spec review, onboarding new hire
- Sam: Incident postmortem from Tuesday, deploying hotfix

## Blockers
- Auth v2 blocked on IAM team approving new scopes (raised March 26)

## Recent Decisions
- March 27: Adopting OpenTelemetry for distributed tracing (decided by Jordan)
- March 25: Pushing API v3 deprecation to May (decided by Sam)

## Wins
- Alex shipped token refresh flow to staging
- Sam resolved the cert rotation incident (4h MTTR)
```

Thirty seconds to know where the team stands. No meetings required.

## Upgrade Path: Inngest Events

Pull-based coordination (read on `/start`, post on `/end`) works for most teams. If you need real-time awareness, you can layer on push-based events through Inngest.

With Inngest enabled, MARVIN emits events when things happen:

- `marvin/digest.posted` when someone finishes a session
- `marvin/blocker.raised` when a blocker is flagged
- `marvin/blocker.resolved` when a blocker is cleared
- `marvin/decision.made` when a team decision is recorded

Other MARVINs can subscribe to these events and react without waiting for `/start`. This turns team mode from "check the board when you arrive" into "get notified when something matters."

When to consider the upgrade:

- Your team is distributed across time zones and pull-based lag matters
- Blockers need immediate visibility, not next-session visibility
- You want automated workflows triggered by team events (e.g., notify on-call when a blocker is raised)

To enable, uncomment the `inngest` section in `team.yaml` and provide your Inngest app ID. The architectural pattern is documented in [docs/patterns/team-mode.md](patterns/team-mode.md).

## FAQ

**Can I be on multiple teams?**
Not yet. One `.marvin-team/` plugin per workspace. If you need multiple teams, use separate MARVIN workspaces. Git worktrees work well for this.

**What if I don't want to post digests?**
Decline when prompted at `/end`, or skip the team step entirely. Digest posting is always opt-in when `require_approval` is true, which is the default.

**Does this work without internet?**
Partially. Your personal MARVIN works fine offline. Team features require connectivity to reach shared surfaces (Slack, Notion, etc.). If you're offline, MARVIN skips the team section and catches up on your next connected session.

**What about sensitive information in digests?**
Digests are drafted by MARVIN and reviewed by you before posting. You see exactly what will be shared and can edit or decline. Nothing is posted automatically with the default settings.

**How many team members can this support?**
There is no hard limit. The practical ceiling depends on your shared surface. A Slack channel handles dozens of digests cleanly. A single Google Doc gets noisy past 8-10 active members. For larger teams, consider splitting into sub-teams with separate plugins or using Notion/Confluence databases that scale better.

**Does team mode affect my personal MARVIN?**
No. Team mode is purely additive. Your personal briefing, session logs, and state files work exactly the same way. Team mode adds a TEAM section to your `/start` briefing and a digest step to `/end`. Remove `.marvin-team/` (keeping `_template/` if you want) and it deactivates completely.

**Can I customize the digest format?**
Yes. Edit `.marvin-team/digest/format.md` to change the template MARVIN uses when drafting digests. Share the update with your team so everyone's digests follow the same structure.
