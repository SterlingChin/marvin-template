# Facebook Manager Skill

Manage Facebook business pages with strict safety guardrails built in.

## What This Skill Does

- Monitors your Facebook pages for new posts
- Reposts content to other pages with automatic safety checks
- Analyzes comments for toxicity and hate speech
- Generates daily briefings of page activity
- Auto-pauses on crisis or self-harm mentions
- Always requires your confirmation before posting

## Safety First

This skill includes strict guardrails that:
- Block hate speech and discriminatory content
- Flag negative/toxic comments
- Detect and pause on mentions of self-harm or suicide
- Require human confirmation before any posts
- Log all actions for audit purposes

## Getting Started

First, set up the integration:
```bash
./integrations/facebook/setup.sh
```

This will guide you through:
1. Creating a Meta App (if you don't have one)
2. Getting your API credentials
3. Selecting which pages to monitor
4. Configuring safety thresholds

## Try These Commands

### Get Page Briefing
"Give me a briefing of my Facebook page activity"
"What's the latest on my page?"

### Analyze Posts
"What posts are on my page?"
"Show me the last 5 posts with engagement"

### Repost Content
"Repost my latest post to my backup page"
"Repost the top 3 posts"

### Check Comments
"Analyze comments on my latest post"
"Show me flagged comments"

### Control
"Pause Facebook manager"
"Resume monitoring"

## How It Works

### Page Monitoring
The skill watches your selected page and can:
- Display new posts in your daily briefing
- Extract post text, likes, and engagement
- Show when posts were created

### Safety Filtering
Every piece of content goes through:
1. **Crisis Detection** - Checks for self-harm/violence mentions
2. **Hate Speech Check** - Detects slurs and discriminatory language
3. **Sentiment Analysis** - Measures negativity level
4. **Spam Detection** - Flags repetitive/spam patterns

### Reposting Workflow
1. You ask MARVIN to repost something
2. MARVIN fetches the post
3. MARVIN runs safety checks
4. MARVIN shows you a preview
5. You confirm or cancel
6. MARVIN posts (only if confirmed)

## Important Safety Notes

### What Gets Auto-Paused 🚨
- Mentions of suicide or self-harm
- Content glorifying violence
- Abuse or trafficking references
- Emergency cries for help

When auto-paused, MARVIN stops all posting and waits for you to review.

### What Requires Your Confirmation
- Every post/repost action
- Any content modification
- Comment actions

### What's Never Posted
- Hate speech
- Content that violates page policies
- Spam or deceptive content
- Anything flagged by safety filters

## Danger Zone ⚠️

These actions can affect your public presence:

| Action | Risk | Notes |
|--------|------|-------|
| Repost to page | High | Visible to all followers |
| Delete posts | High | Cannot be undone |
| Modify posts | Medium | Changes visible to all |
| Manage comments | Medium | Affects user experience |
| Read comments | Low | Only retrieves data |

**Always review previews before confirming actions.**

## Troubleshooting

**"Can't access your page"**
- Make sure you're an admin on the page
- Verify the page ID is correct
- Rerun setup.sh to reconfigure

**"Posts are being blocked"**
- Check if content has safety flags
- Review the flagged keywords
- Try rephrasing the content

**"Setup won't complete"**
- Ensure Python 3 is installed
- Check your Meta App credentials
- Verify internet connection

**"Repost failed"**
- Check target page permissions
- Verify page accepts programmatic posting
- Try posting directly to page first

## See Also

- `.marvin/integrations/facebook/README.md` - Full integration docs
- `.marvin/integrations/facebook/CLAUDE.md` - Technical implementation guide
- `/help` - All available commands
