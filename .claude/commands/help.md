---
description: Show available commands and integrations
---

# /help - MARVIN Help

Show the user what MARVIN can do and what integrations are available.

## Instructions

### 1. Show Available Commands

Display this reference:

```
## Slash Commands

| Command   | What It Does                        |
|-----------|-------------------------------------|
| /start   | Start a session with a briefing     |
| /end      | End session and save everything     |
| /update   | Quick checkpoint (save progress)    |
| /report   | Generate a weekly summary of work   |
| /commit   | Review and commit git changes       |
| /code     | Open MARVIN in your IDE             |
| /status   | Check integration & workspace health|
| /help     | Show this help guide                |
| /sync     | Get updates from MARVIN template    |
```

### 2. Show Current Integrations

Check what MCP servers are configured by running:
```bash
claude mcp list
```

Then display something like:

```
## Your Integrations

These are the tools MARVIN can currently access:

| Integration      | What It Does                                      |
|------------------|---------------------------------------------------|
| Google Workspace | Read/send email, check calendar, access Drive     |
| Atlassian        | View Jira tickets, search Confluence              |

(List only what's actually configured based on the mcp list output)
```

If no integrations are configured, say:
```
## Your Integrations

No integrations configured yet. Just say "Help me connect to Jira" or "Set up Microsoft 365" and I'll walk you through it!
```

### 3. Show Available Integrations

Display what integrations can be added:

```
## Available Integrations

Just ask me to set one up! For example: "Help me connect to Jira"

| Integration      | What It Does                              |
|------------------|-------------------------------------------|
| Atlassian        | Jira tickets, Confluence pages            |
| Microsoft 365    | Outlook email, Calendar, OneDrive, Teams  |
| Google Workspace | Gmail, Calendar, Drive (advanced setup)   |
| Slack            | Team messaging, channels, search          |
| Notion           | Pages, databases, wikis                   |
| Linear           | Issues, projects, tracking                |

Want something else? Check `.marvin/integrations/REQUESTS.md` to see what's planned or request a new one!
```

### 4. Offer Next Steps

End with:

```
---

Want me to help you set up an integration, create a new skill, or learn more about what I can do?

Otherwise, hit **Esc** to get back to work.
```

Wait for the user to respond or exit.
