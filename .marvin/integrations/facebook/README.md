# Facebook Social Media Manager Integration

Connect MARVIN to Facebook to manage a business page with strict safety guardrails.

## What It Does

- **Watch Pages**: Monitor a specific Facebook page for new posts
- **Repost Content**: Automatically repost page content to another page or account
- **Smart Filtering**: Reject hate speech, negative comments, and crisis indicators
- **Safety First**: Never responds to harmful requests or vulnerable situations

## Safety Guardrails

### Content MARVIN Will NOT Handle:
- **Hate Speech & Discrimination**: Any content targeting protected groups
- **Negative Comments**: Spam, trolling, abusive language
- **Crisis Indicators**: Mentions of self-harm, suicide, abuse, or violence
- **Misinformation**: False or misleading health/political claims
- **Financial Scams**: Suspicious money-making schemes or fraud

### What Gets Flagged:
- Posts containing violence or threats
- Content promoting illegal activities
- Messages requesting emergency help (redirected to proper services)
- Self-harm or suicide mentions (auto-pause + human review)

## Prerequisites

- Facebook account with admin access to pages
- Meta App with Graph API permissions
- API credentials (App ID & Access Token)

## Setup

```bash
./integrations/facebook/setup.sh
```

Setup walks you through:
1. Creating a Meta App (if needed)
2. Getting API credentials
3. Configuring page IDs
4. Setting up safety thresholds
5. Testing the connection

## Try It

Once configured, you can ask MARVIN:

- "Watch my Facebook page for new posts"
- "What's the latest activity on my page?"
- "Repost the last 5 posts to my backup page"
- "Show me engagement metrics"
- "Pause social media manager" (for safety concerns)

## Danger Zone ⚠️

This integration performs actions affecting your public presence:

| Action | Risk | Who's Affected |
|--------|------|------------------|
| Post/Repost | High | All page followers |
| Delete posts | High | Visible to all |
| Comment moderation | Medium | Comment authors |
| Moderate comments | Medium | Comment authors |
| Read page data | Low | No external impact |

**MARVIN will always confirm before posting or deleting.**

## Safety Limits

- **Max Posts Per Session**: 5 reposts
- **Engagement Threshold**: Comments with <-3 sentiment ignored
- **Auto-Pause Triggers**: Self-harm, violence, or emergency mentions
- **Human Review Required**: Flagged content held for review

## Troubleshooting

**"Invalid Access Token"**
- Run setup.sh again to refresh credentials
- Check that your Meta App hasn't been revoked

**"Permission Denied"**
- Ensure your account is an admin on the target page
- Verify the page ID is correct

**"Post failed"**
- Check page posting is enabled
- Verify the page accepts programmatic posting

**Safety Feature Blocking Posts?**
- Posts are flagged if they contain prohibited content
- Review the content and try rephrasing
- Contact admin for exceptions
  
## Contributing Authors
- Sterling Chin (Original MARVIN template)
- Paula Nunez (Zed v2.0👾) (Facebook integration & guardrails)
Extended with Facebook integration and strict social media guardrails
