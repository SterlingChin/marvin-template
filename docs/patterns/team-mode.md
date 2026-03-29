# Team Mode Pattern

Shared awareness across multiple MARVIN instances on the same team. Each person runs their own MARVIN locally. Shared context flows through existing team tools.

## Why Team Mode?

When multiple people run MARVIN, each instance is an island. Your MARVIN knows everything about your work, but nothing about what your teammates are doing, what decisions were made while you were offline, or what blockers are affecting the team.

Team mode connects MARVINs through tools the team already uses: Slack, Google Docs, Confluence, Notion, Jira, Linear, GitHub. No new infrastructure, no servers, no shared databases.

## Architecture

Team mode is a plugin. A `.marvin-team/` directory in your workspace declares WHERE shared context lives. Each MARVIN reads from and writes to those shared surfaces.

```
MARVIN-A (PM)           MARVIN-B (Engineer)      MARVIN-C (EM)
    |                        |                        |
    |-- /end: post digest    |                        |
    |       |                |                        |
    |       v                |                        |
    |   +--------------------------------------------+|
    |   |        Shared Context Layer                ||
    |   |  (Slack, Google Docs, Confluence, etc.)    ||
    |   +--------------------------------------------+|
    |                        |                        |
    |                   /start: read ----------> /start: read
    |                   team context              team context
```

There is no direct communication between MARVIN instances. Everything flows through the shared context layer, which is just your team's existing tools.

### How MARVINs Share Context

1. **Each MARVIN reads shared surfaces on `/start`** (pull-based). Priorities, recent digests, and blockers are fetched from whichever tools the team configured.
2. **Each MARVIN posts digests to shared surfaces on `/end`**. After summarizing the session, MARVIN drafts a digest and asks for approval before posting.
3. **Digests become inputs for other MARVINs on their next `/start`**. When a teammate starts a session, their MARVIN sees what you shipped, what decisions you made, and what blockers you raised.
4. **No direct MARVIN-to-MARVIN communication needed.** The shared surfaces are the coordination layer.

### Key Decisions

| Decision | What we learned |
|----------|----------------|
| Plugin over service | A file you share beats a service you maintain |
| Existing tools as bus | Teams already have Slack/Docs/Confluence. Use them. |
| Pull-based by default | Read on /start, post on /end. Simple, no infra. |
| Roles are optional | Same data, different emphasis. Not a hard boundary. |
| Inngest as upgrade | Push-based coordination when pull-based isn't enough. |
| Always require digest approval | Trust is earned. Never auto-post on behalf of the user. |

## Directory Structure

```
.marvin-team/
├── team.yaml              # Plugin config (shared with team)
├── my-role.yaml           # Your role selection (local only)
├── README.md              # Quick start for new members
├── roles/
│   ├── _template.yaml     # Template for custom roles
│   ├── engineer.yaml      # Engineer role profile
│   ├── pm.yaml            # Program Manager role profile
│   └── em.yaml            # Engineering Manager role profile
├── digest/
│   └── format.md          # Digest template
└── _template/             # Pristine template (do not edit)
    └── ...                # Same structure as above
```

**Shared with team:** `team.yaml`, `roles/`, `digest/`, `README.md`
**Local only:** `my-role.yaml` (your role selection)

## Configuration: team.yaml

The `team.yaml` file declares which tools your team uses for shared context. It has three sections:

### Shared Context (where data lives)

```yaml
shared_context:
  slack:
    digest_channel: "#eng-marvin-updates"
    monitor_channels:
      - "#eng-general"
      - "#eng-blockers"

  google:
    priorities_doc_id: "1abc..."
    decisions_doc_id: "1def..."

  jira:
    projects:
      - key: "ENG"
        name: "Engineering"
```

Supported tools: Slack, Google Docs, Confluence, Notion, Jira, Linear, GitHub. Configure only the ones your team uses.

### Behaviors (what MARVIN does)

```yaml
behaviors:
  on_start:
    - read_team_priorities
    - read_recent_digests
    - check_team_blockers

  on_end:
    - post_digest
    - update_decisions
    - update_blockers
```

### Digest Settings

```yaml
  digest:
    format: "digest/format.md"
    post_to: "slack"
    require_approval: true      # Always confirm before posting
```

`require_approval: true` is the default and the recommended setting. MARVIN never posts to shared surfaces without your explicit approval.

## Roles

Role profiles control what each MARVIN prioritizes when reading shared context. They don't restrict access. Every MARVIN can see everything. Roles just change what gets surfaced first.

**Available presets:**

| Role | Prioritizes | De-prioritizes |
|------|------------|----------------|
| Engineer | PRs, bugs, incidents, deployments | Epics, timelines, process |
| Program Manager | Epics, dependencies, risks, timelines | Individual PRs, incidents |
| Engineering Manager | Team velocity, blockers, hiring, process | Individual code changes |

**Custom roles:** Copy `roles/_template.yaml` and define your own `priorities` and `context_sources` lists. Any YAML file in `roles/` (except `_template.yaml`) becomes an available role.

## Getting Started

**Team lead:** Run `/team init` and follow the prompts. Share the generated `.marvin-team/` directory with your team.

**Team members:** Copy the `.marvin-team/` directory into your workspace and run `/team join`. Pick your role. Run `/start` to see your team briefing.

Full setup instructions: [Team Setup Guide](../team-setup.md)

## Inngest Upgrade Path (Level 2)

Pull-based awareness (read on `/start`) works for most teams. But if your team needs real-time coordination, you can enable push-based events through Inngest.

With Inngest enabled, MARVIN emits events when things happen:
- `marvin/digest.posted` when someone posts a session digest
- `marvin/blocker.raised` when a blocker is flagged
- `marvin/blocker.resolved` when a blocker is cleared
- `marvin/decision.made` when a team decision is recorded

Other MARVINs can subscribe to these events and react without waiting for `/start`. This turns team mode from "check the board when you start" into "get notified when something matters."

To enable, uncomment the `inngest` section in `team.yaml` and provide your Inngest app ID. See the [Inngest docs](https://www.inngest.com/docs) for setup.

## Tips

- Start with one shared surface (Slack or Google Docs) and add more as needed
- Keep digest approval on. You'll trust it more if you always see what's being posted.
- Roles are optional. A team of engineers with the same role still benefits from shared digests.
- The `_template/` directory preserves the original config. Don't edit it directly.
- Run `/team status` to check tool connectivity and see recent team activity.
