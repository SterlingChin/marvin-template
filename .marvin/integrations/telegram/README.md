# Telegram Integration

Connect MARVIN to Telegram for a full AI assistant experience on mobile.

## What It Does

- **Chat with MARVIN** - Full conversational AI via Telegram
- **Read/write files** - Access your MARVIN workspace from anywhere
- **Fetch URLs** - Get YouTube transcripts, Reddit posts, articles
- **Search files** - Find content across your notes and documents
- **Send files** - Get documents delivered as Telegram attachments
- **Image analysis** - Send photos for Claude to analyze
- **Conversation history** - Context persists across messages

## Who It's For

Anyone who wants MARVIN accessible from their phone. Perfect for:
- Capturing ideas on the go
- Quick file lookups while away from your desk
- Sending links for MARVIN to process and save
- Mobile-first workflows

## Prerequisites

- Python 3.10+
- A Telegram account
- An Anthropic API key (`ANTHROPIC_API_KEY` in your environment)

## Setup

```bash
./.marvin/integrations/telegram/setup.sh
```

The script will guide you through:
1. Creating a Telegram bot via BotFather
2. Installing Python dependencies
3. Configuring your bot token
4. Setting up user authorization (optional)

## Running the Bot

After setup, start the bot:

```bash
./.marvin/integrations/telegram/run.sh
```

Or run directly:

```bash
cd .marvin/integrations/telegram
source venv/bin/activate
python telegram_bot.py
```

**Tip:** Run the bot in a terminal tab, tmux session, or as a background process to keep it available.

## Try It

After setup, message your bot on Telegram:

- "What's in my current state?"
- "Search for meeting notes from last week"
- "Save this to my inbox: [your idea]"
- Send a YouTube link - "Summarize this video"
- Send a photo - "What's in this image?"
- "Send me the file at content/notes.md"

## Bot Commands

| Command | What It Does |
|---------|--------------|
| `/start` | Introduction and capabilities |
| `/help` | Show available commands |
| `/clear` | Clear conversation history |
| `/status` | Check bot status |
| `/save [topic]` | Save conversation summary to session log |

## Configuration

### Environment Variables

Set these in `.env` or your environment:

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | Bot token from BotFather |
| `ANTHROPIC_API_KEY` | Yes | Your Anthropic API key |
| `TELEGRAM_ALLOWED_USERS` | No | Comma-separated user IDs for authorization |

### User Authorization

For security, you can restrict the bot to specific Telegram users:

1. Message your bot and run `/status` to see your user ID
2. Add to `.env`: `TELEGRAM_ALLOWED_USERS=123456789`
3. Multiple users: `TELEGRAM_ALLOWED_USERS=123456789,987654321`

If not set, the bot accepts messages from anyone (not recommended for production).

## Danger Zone

This integration has access to your MARVIN workspace:

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Write/overwrite files | **Medium** | Your local workspace |
| Delete files | **Medium** | Your local workspace |
| Read files | Low | No external impact |
| Fetch URLs | Low | No external impact |

**Security considerations:**
- Set `TELEGRAM_ALLOWED_USERS` to restrict who can use your bot
- The bot token grants full control - keep it secret
- Files are only accessible within your MARVIN workspace (sandboxed)

**MARVIN will confirm before overwriting existing files.**

## Troubleshooting

**"Unauthorized" when messaging the bot**
- Check that your user ID is in `TELEGRAM_ALLOWED_USERS`
- Run `/status` to verify your user ID

**Bot not responding**
- Ensure the bot process is running
- Check that `TELEGRAM_BOT_TOKEN` is set correctly
- Verify `ANTHROPIC_API_KEY` is valid

**"Could not fetch transcript" for YouTube**
- Some videos have transcripts disabled
- Try a different video to verify the feature works

**Python errors on startup**
- Make sure you're using Python 3.10+
- Activate the virtual environment: `source venv/bin/activate`
- Reinstall dependencies: `pip install -r requirements.txt`

## Architecture

This integration runs as a standalone Python process (not an MCP server). It:
- Uses the `python-telegram-bot` library for Telegram API
- Calls Claude directly via the Anthropic SDK with tool use
- Stores conversation history in SQLite (`telegram.db`)
- Has access to your MARVIN workspace for file operations

## Files

| File | Purpose |
|------|---------|
| `telegram_bot.py` | Main bot with Claude integration |
| `content_fetcher.py` | URL content extraction (YouTube, Reddit, etc.) |
| `requirements.txt` | Python dependencies |
| `setup.sh` | Installation script |
| `run.sh` | Start script |

---

*Contributed by Sterling Chin*
