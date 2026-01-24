# MARVIN Integrations

This directory contains integrations that extend MARVIN's capabilities. Each integration connects MARVIN to external tools and services.

---

## Available Integrations

| Integration | Description | Setup |
|-------------|-------------|-------|
| [Google Workspace](./google-workspace/) | Gmail, Calendar, Drive | `./.marvin/integrations/google-workspace/setup.sh` |
| [Atlassian](./atlassian/) | Jira, Confluence | `./.marvin/integrations/atlassian/setup.sh` |

---

## How to Install an Integration

1. Browse the folders in this directory (`.marvin/integrations/`)
2. Read the integration's README to see what it does
3. Run its setup script: `./.marvin/integrations/<name>/setup.sh`
4. Restart MARVIN and you're good to go!

Or just ask MARVIN: *"Help me set up the Notion integration"*

---

## Request an Integration

Want MARVIN to connect to a tool that's not here yet?

**Option 1:** Open an issue on GitHub describing what you'd like

**Option 2:** Add it to `.marvin/integrations/REQUESTS.md` and submit a PR

**Option 3:** Build it yourself! See "Contributing" below.

---

## Contributing an Integration

We'd love community contributions! If you've set up MARVIN with a tool you love, share it with others.

### Integration Structure

Each integration should have its own folder:

```
.marvin/integrations/
└── your-integration/
    ├── README.md      # What it does, who it's for, any requirements
    ├── setup.sh       # The setup script (should be interactive and friendly)
    └── AUTHOR.md      # Optional: your name/handle for credit
```

### Guidelines

1. **Make it easy** - Assume the user is non-technical. Use colors, clear prompts, and helpful error messages.

2. **Be safe** - Never store credentials in plain text. Use environment variables or Claude's MCP config.

3. **Test it** - Make sure it works on a fresh install.

4. **Document it** - Your README should explain:
   - What the integration does
   - Who would benefit from it
   - Any prerequisites (accounts, API keys, etc.)
   - Example commands to try after setup

### Example README.md

```markdown
# Notion Integration

Connect MARVIN to your Notion workspace.

## What It Does
- Search your Notion pages and databases
- Read page content
- Create new pages
- Update existing pages

## Who It's For
Anyone who uses Notion for notes, wikis, or project management.

## Prerequisites
- A Notion account
- A Notion integration token (the setup script will guide you)

## Setup
Run: `./.marvin/integrations/notion/setup.sh`

## Try It
After setup, try these commands with MARVIN:
- "Search my Notion for meeting notes"
- "What's in my project tracker?"
- "Create a new page called 'Ideas'"
```

---

## Integration Ideas

Here are some integrations we'd love to see:

- **Notion** - Notes, wikis, databases
- **Slack** - Team messaging
- **Linear** - Issue tracking
- **Figma** - Design files
- **Airtable** - Spreadsheets and databases
- **HubSpot** - CRM
- **Todoist** - Task management
- **Obsidian** - Local markdown notes
- **Raycast** - Quick actions
- **Granola** - Meeting notes

Want to build one? Pick from the list or add your own!

---

*This integrations directory is part of [MARVIN](https://github.com/SterlingChin/marvin-template), the AI Chief of Staff template.*
