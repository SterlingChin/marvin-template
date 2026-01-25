# Google Workspace Integration

Connect MARVIN to your Google account for email, calendar, and file access.

## What It Does

- **Gmail** - Read, search, and send emails
- **Calendar** - View events, check availability, create meetings
- **Drive** - Search and read documents, spreadsheets, slides

## Who It's For

Anyone who uses Google Workspace (Gmail, Google Calendar, Google Drive) for work or personal use.

## Prerequisites

- A Google account
- The OAuth client secret (ask Sterling or check the setup instructions)

## Setup

```bash
./integrations/google-workspace/setup.sh
```

The script will:
1. Check that you have the required tools installed
2. Ask for the OAuth client secret
3. Configure the MCP server
4. Open a browser for you to log in with your Google account

## Try It

After setup, try these commands with MARVIN:

- "What's on my calendar today?"
- "Show me my unread emails"
- "Search my Drive for quarterly reports"
- "What meetings do I have this week?"
- "Send an email to [person] about [topic]"

## Danger Zone

This integration can perform actions that affect others or can't be easily undone:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Send emails | **High** | Recipients see it immediately |
| Create/modify calendar events | **Medium** | Other attendees are notified |
| Delete emails | **Medium** | May be recoverable from trash |
| Read emails, calendar, Drive | Low | No external impact |

**MARVIN will always confirm before sending emails or modifying calendar events.**

## Troubleshooting

**"Client secret is required"**
You need the OAuth client secret. Ask Sterling or check the project documentation.

**Browser doesn't open for login**
Try running the setup script again, or manually visit the URL shown in the terminal.

**"Permission denied" errors**
Make sure you're logging in with the correct Google account and granting all requested permissions.

---

*Created by Sterling Chin*
