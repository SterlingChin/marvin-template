# Facebook Integration Guide for Claude

## Overview
This integration allows Marvin to:
- Monitor a Facebook page for new posts
- Repost content with safety checks
- Analyze comments for toxicity
- Generate briefings on page activity

## Key Features

### 1. Page Monitoring
```
User: "Watch my Facebook page"
MARVIN: Sets up page watch with safety filters enabled
```

### 2. Reposting with Confirmation
```
User: "Repost the latest 3 posts to my backup page"
MARVIN: 
1. Fetches posts
2. Analyzes for safety
3. Requests confirmation for each
4. Posts only after approval
```

### 3. Safety Analysis
All content is analyzed for:
- Crisis/self-harm indicators (auto-pauses)
- Hate speech patterns
- Toxic comments
- Spam detection

## Integration Implementation

### Available Classes

**FacebookPageManager**
- `get_page_posts(limit=10)` - Get recent posts
- `get_page_info()` - Get page details
- `get_post_comments(post_id)` - Get post comments
- `repost_content(post_id)` - Create repost (pending confirmation)
- `confirm_and_repost(post_id, confirmed=True)` - Execute repost
- `generate_briefing()` - Create activity summary

**ContentGuardrails**
- `analyze_content(text)` - Check safety of content
- `filter_comments(comments)` - Filter comment list
- `generate_safety_report(comments)` - Create safety report

## Usage in Skills
```python
from facebook_manager import FacebookPageManager
from guardrails import ContentGuardrails

manager = FacebookPageManager()
guardrails = ContentGuardrails()

# Get posts
posts = manager.get_page_posts(limit=5)

# Check safety
for post in posts:
    safety = guardrails.analyze_content(post.get('message', ''))
    if safety['safe']:
        print("✅ Safe to rep
