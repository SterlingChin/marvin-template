# Advanced Patterns

Architectural blueprints for building powerful MARVIN capabilities. These patterns come from production use and are documented as guides, not working code.

## Patterns

| Pattern | What It Covers |
|---------|---------------|
| [CLI Integration](cli-integration.md) | Wrapping CLI tools as MARVIN skills |
| [Content Pipeline](content-pipeline.md) | End-to-end content creation workflow |
| [Meeting Processing](meeting-processing.md) | Combining AI summaries with transcription |
| [Multi-Source Research](multi-source-research.md) | Fanning out to multiple AI providers |
| [Always-On Daemon](always-on-daemon.md) | Background service for scheduled tasks |
| [Mobile Access](mobile-access.md) | Running MARVIN from your phone |
| [Parallel Worktrees](parallel-worktrees.md) | Multiple simultaneous sessions |
| [Team Mode](team-mode.md) | Shared awareness across multiple MARVIN instances |

## How to Use These

Each pattern documents:
- **What it does** and why you'd want it
- **Architecture** with diagrams and component descriptions
- **Key decisions** learned from production use
- **Directory structure** for organizing files
- **Getting started** steps to implement it yourself

Start with the patterns that match your needs. You don't need all of them. Most users benefit from the content pipeline and parallel worktrees first.

## Contributing

Have a pattern that works well for you? Submit a PR following the same structure: what, why, architecture, decisions, directory structure, getting started.
