# Team Plugin

This directory configures MARVIN for team mode. When present in your workspace, your MARVIN shares context with other team members' MARVINs through your team's existing tools.

## Quick Start

**If you received this from your team lead:**
1. Copy this `.marvin-team/` directory into your MARVIN workspace
2. Run `/team join` inside MARVIN
3. Select your role when prompted
4. Run `/start` to see your team briefing

**If you're setting up a new team:**
1. Run `/team init` inside MARVIN
2. Follow the prompts to configure your team's tools
3. Share the generated `.marvin-team/` directory with your team

## What Team Mode Does

**On `/start`:** Your briefing includes a TEAM section showing what teammates have been working on, decisions made since your last session, and active blockers.

**On `/end`:** MARVIN drafts a team digest summarizing your session and asks for your approval before posting it to your team's shared channel or doc.

## Configuration

Edit `team.yaml` to change:
- Which tools to use for shared context (Slack, Google Docs, Confluence, Notion)
- Which work tracking system to monitor (Jira, Linear, GitHub)
- Digest posting destination and format
- Team behaviors (what to read on start, what to post on end)

## Roles

Role profiles in `roles/` control what each MARVIN prioritizes:
- **Engineer:** PRs, bugs, incidents, deployments
- **Program Manager:** Epics, dependencies, risks, timelines
- **Engineering Manager:** Team velocity, blockers, hiring, process

Your role is stored locally in `my-role.yaml` and doesn't affect other team members.

Custom roles: copy `roles/_template.yaml` and customize.

## Updating

When your team lead updates the plugin config, run `/team sync` to pull changes. Your role selection and personal settings are preserved.

## Inngest Integration (Optional)

For push-based team awareness (real-time notifications instead of checking on `/start`), enable the Inngest section in `team.yaml`. See `docs/patterns/team-mode.md` for details.
