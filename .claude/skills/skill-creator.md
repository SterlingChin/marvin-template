---
name: skill-creator
description: Create new MARVIN capabilities on request. Triggers on "give yourself the ability to X" or "create a skill for Y"
---

# Skill Creator

Create new MARVIN capabilities based on user requests. Determines whether the request is best served by a command, agent, or skill, and creates the appropriate file.

## When to Use

Claude Code should invoke this skill when it detects:
- "Give yourself the ability to..."
- "Create a skill for..."
- "Add a workflow for..."
- "I want MARVIN to be able to..."
- "Make a command for..."
- "Add an agent for..."

## How It Works

### Step 1: Understand the Request
Clarify:
- What should the capability do?
- When should it trigger?
- What inputs does it need?
- What output should it produce?

### Step 2: Determine the Type

| Type | When to Use | Location |
|------|-------------|----------|
| **Command** | User-triggered workflow with a slash command (e.g., `/review`) | `.claude/commands/{name}.md` |
| **Agent** | Autonomous delegated work MARVIN spawns via Task tool | `.claude/agents/{name}.md` |
| **Skill** | Contextual capability that activates when relevant | `.claude/skills/{name}.md` |

**Decision guide:**
- Does the user explicitly invoke it? → **Command**
- Does MARVIN delegate a chunk of work to it? → **Agent**
- Does it activate based on context/patterns? → **Skill**

### Step 3: Create the File

**For a command** (`.claude/commands/{name}.md`):
```markdown
---
description: One-line description shown in /help
---

# /{name} - Title

Instructions for what this command does when invoked.

## Steps
1. First step
2. Second step
```

**For an agent** (`.claude/agents/{name}.md`):
```markdown
---
name: agent-name
description: One-line description of what this agent does
model: sonnet
---

# Agent Name

## Purpose
What this agent is responsible for.

## When to Spawn
- Condition 1
- Condition 2

## Capabilities
What the agent can do.
```

**For a skill** (`.claude/skills/{name}.md`):
```markdown
---
name: skill-name
description: One-line description of what this skill does
---

# Skill Name

## When to Use
Claude Code should invoke this skill when:
- Context 1
- Context 2

## How It Works
Step-by-step process.
```

### Step 4: Confirm Creation
Tell the user:
- What was created and where
- How to trigger it
- Ready to use immediately

## Output Format

```
Created: **{type}** - {name}
- Location: `.claude/{type}s/{name}.md`
- Trigger: {how to use it}

Ready to use.
```

## Notes

- Use the templates in `.claude/agents/_template.md` and `.claude/skills/_template.md` as reference
- Keep capabilities focused on one task
- Include clear trigger conditions
- Commands need a `description` in frontmatter for `/help` to display them
