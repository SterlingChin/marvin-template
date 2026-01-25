# Parallel Search Integration

Connect MARVIN to the web with fast, parallel search capabilities.

## What It Does

- **Web Search** - Search the web and get LLM-friendly results
- **Web Fetch** - Extract relevant content from specific URLs

## Who It's For

Anyone who wants MARVIN to have access to current information from the web.

## Prerequisites

None! This is a free, hosted MCP service.

## Setup

```bash
./.marvin/integrations/parallel-search/setup.sh
```

The script will configure the Parallel Search MCP server for Claude Code.

## Try It

After setup, try these commands with MARVIN:

- "Search the web for latest React documentation"
- "What's new in Python 3.12?"
- "Find recent news about AI developments"
- "Look up the current price of Bitcoin"

## Tools Available

### web_search_preview
Search the web with natural language queries. Returns results optimized for LLMs.

### web_fetch
Fetch and extract relevant content from specific URLs. Great for exploring search results in depth.

## Danger Zone

This integration is **read-only** and cannot modify external data.

| Action | Risk Level | Who's Affected |
|--------|------------|----------------|
| Web search | Low | No external impact |
| Fetch URL content | Low | No external impact |

No confirmation needed - this integration only reads public web content.

## Troubleshooting

**Search returns no results**
Try rephrasing your query or being more specific.

**Timeout errors**
The service may be temporarily busy. Wait a moment and try again.

---

*Created by Sterling Chin*
