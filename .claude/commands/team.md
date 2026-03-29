---
description: "Team mode: init, join, sync, status"
---

# /team - Team Mode Management

Manage MARVIN's team mode for shared context across multiple MARVIN instances.

## Usage

```
/team init      Create a new team plugin
/team join      Install a team plugin and select your role
/team sync      Pull updates from your team's plugin source
/team status    Show team mode health and configuration
```

## Routing

Read `$ARGUMENTS`. Match the first word to a subcommand below. If no arguments or unrecognized, show the usage block above.

---

## /team init

Create a new team plugin for your team. This generates a `.marvin-team/` directory that you share with your team.

### Steps

#### 1. Check for Existing Plugin
If `.marvin-team/team.yaml` already exists (not in `_template/`):
> "You already have a team plugin configured ([team name]). Want to create a new one? This will replace the existing plugin."

If they decline, stop.

#### 2. Gather Team Info

Ask these questions one at a time:

**Team name:**
> "What's your team name?"

**Communication tool:**
> "Where does your team communicate for updates? (Slack channel, or skip)"

If Slack: ask for the digest channel name (e.g., "#eng-marvin-updates") and any channels to monitor.

**Knowledge base:**
> "Where should team decisions and priorities live?"
> Options:
> - Google Docs (I'll create or use existing docs)
> - Confluence (provide space key and page IDs)
> - Notion (provide page/database IDs)
> - Skip for now

If Google Docs: ask if they want to create new docs or use existing ones. If new, create them using the gws CLI or Google Workspace tools. If existing, ask for doc IDs.

If Confluence: ask for space key, decisions page ID, priorities page ID.

If Notion: ask for page/database IDs.

**Work tracking:**
> "Where does your team track work?"
> Options:
> - Jira (provide project keys)
> - Linear (provide team ID)
> - GitHub (provide repo names)
> - Skip for now

**Digest destination:**
> "Where should team digests be posted?"

This should match one of the configured tools above. If Slack is configured, default to Slack. If only Google Docs, default to Google Docs.

**Roles:**
> "Want to set up role profiles? Roles let different team members see different priorities."
> "Available presets: Engineer, Program Manager (PM), Engineering Manager (EM)"
> "You can also create custom roles later."

If yes: which presets to include? Copy selected role files from `_template/roles/`.

#### 3. Generate Plugin

1. Copy `.marvin-team/_template/` to `.marvin-team/` (as working config, alongside the template)
   - Actually: create a NEW `.marvin-team/` at workspace root with the populated files
   - Copy `team.yaml` from template, uncomment and fill in the configured sections
   - Copy selected role files to `roles/`
   - Copy `digest/format.md` and `README.md`
2. Write the populated `team.yaml` with the gathered values
3. Set `behaviors.digest.post_to` based on their choice

#### 4. Set Own Role
If roles were configured:
> "What's your role on the team?"

Save choice to `.marvin-team/my-role.yaml`:
```yaml
role: "Program Manager"  # or whatever they chose
selected_at: "2026-03-28"
```

#### 5. Confirm

> "Team plugin created for [team name]!"
> "  Location: .marvin-team/"
> "  Tools: [list configured tools]"
> "  Your role: [role]"
> ""
> "Share the `.marvin-team/` directory with your team. They can install it with `/team join`."
> "Run `/start` to see your team briefing."

#### 6. Commit (optional)
Offer to commit the new plugin:
> "Want me to commit the team plugin? (y/n)"

If yes:
```bash
git add .marvin-team/
git commit -m "feat: add team plugin for [team name]"
```

---

## /team join

Install a team plugin and configure your role.

### Steps

#### 1. Find the Plugin

Check if `.marvin-team/team.yaml` already exists at workspace root (not in `_template/`).

If it exists: "Team plugin found: [team name]. Want to reconfigure your role, or set up a different team?"

If it doesn't exist: check if `$ARGUMENTS` includes a path:
- `/team join ./path/to/.marvin-team` — copy from that path
- `/team join` (no path) — check if `.marvin-team/_template/team.yaml` exists and ask if they want to use the template

If no plugin found anywhere:
> "No team plugin found. Ask your team lead for the `.marvin-team/` directory, or run `/team init` to create one."

#### 2. Validate Configuration

Read `team.yaml` and check each configured tool:
- **Slack:** Check if Slack MCP is connected (attempt a simple read)
- **Google Docs:** Check if `gws` CLI is available or Google Workspace MCP connected
- **Confluence/Jira:** Check if Atlassian MCP is connected
- **Notion:** Check if Notion MCP is connected
- **Linear:** Check if Linear MCP is connected
- **GitHub:** Check if `gh` CLI is available

For each tool:
- Available: note as connected
- Not available: warn but don't block ("Slack is configured but not connected. Team digests from Slack won't be visible until you set it up.")

#### 3. Select Role

If `roles/` directory has profiles (beyond `_template.yaml`):
> "What's your role?"

List available roles from the YAML files. Also offer "Custom" and "Skip".

Save to `.marvin-team/my-role.yaml`:
```yaml
role: "Engineer"
selected_at: "2026-03-28"
```

If no roles defined, skip this step.

#### 4. Confirm

> "Team mode active!"
> "  Team: [team name]"
> "  Your role: [role or 'none']"
> "  Connected: [list of working tools]"
> "  Not connected: [list of tools configured but not reachable]"
> ""
> "Run `/start` to see your team briefing."

---

## /team sync

Check for and apply updates to the team plugin configuration.

### Steps

#### 1. Check for Source

Look for `.marvin-team/source` file containing the path to the plugin source (set during `/team join` if installed from a path).

If no source file: "No sync source configured. If your team lead updated the plugin, copy the new `.marvin-team/` directory and run `/team join` again."

#### 2. Compare Configs

If source exists, compare `team.yaml` between source and local:
- New tools added
- Tool config changes (new channels, projects, etc.)
- New roles added
- Removed tools or roles

#### 3. Show Changes

> "Updates available from [source path]:"
> "- Added: Slack channel #new-channel to monitor list"
> "- Changed: Jira project INFRA added"
> "- New role: Designer"

#### 4. Apply

> "Apply these updates? Your role selection (my-role.yaml) will be preserved. (y/n)"

If yes: copy updated files, preserve `my-role.yaml`.

#### 5. Confirm

> "Team plugin updated. Run `/start` to see the changes."

---

## /team status

Show team mode configuration and health.

### Steps

#### 1. Check Team Mode

If `.marvin-team/team.yaml` doesn't exist:
> "Team mode: not configured. Run `/team init` to create a team, or `/team join` to install a team plugin."
> Stop.

#### 2. Load Config

Read `team.yaml` and `my-role.yaml`.

#### 3. Check Tool Health

For each configured tool, do a lightweight read-only health check (same as validation in `/team join`).

#### 4. Present Status

```
## Team Mode Status

**Team:** [name]
**Your role:** [role or 'not set']

### Connected Tools
| Tool | Status | Details |
|------|--------|---------|
| Slack | Connected | Digest: #eng-updates, Monitoring: #eng-general, #blockers |
| Google Docs | Connected | 3 docs configured |
| Jira | Not connected | Atlassian MCP not configured |

### Digest Settings
- Post to: [destination]
- Approval required: Yes
- Format: digest/format.md

### Team Activity
- Last digest posted: [date, or "never"]
- Team members seen: [names from recent digests, or "none yet"]

### Issues
- [Any problems detected]
```

If everything is healthy: "All systems go. Run `/start` for your team briefing."
If issues found: offer to help fix them.
