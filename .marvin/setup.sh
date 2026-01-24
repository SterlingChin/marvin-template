#!/bin/bash

# MARVIN Setup Script
# Interactive setup for your personal AI Chief of Staff

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print with color
print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$CYAN" "$1"
    print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header "MARVIN Setup"
echo "Welcome! Let's set up your personal AI Chief of Staff."
echo "This will take about 5 minutes."
echo ""

# ============================================================================
# PHASE 1: Prerequisites
# ============================================================================

print_header "Phase 1: Prerequisites"

# Check for Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command_exists brew; then
        print_color "$YELLOW" "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        print_color "$GREEN" "Homebrew installed!"
    else
        print_color "$GREEN" "Homebrew: installed"
    fi
fi

# Check for Claude Code
if ! command_exists claude; then
    print_color "$YELLOW" "Claude Code not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install claude-code
    else
        # For Linux, use npm
        if command_exists npm; then
            npm install -g @anthropic-ai/claude-code
        else
            print_color "$RED" "Please install Claude Code manually:"
            print_color "$RED" "  https://docs.anthropic.com/en/docs/claude-code"
            exit 1
        fi
    fi
    print_color "$GREEN" "Claude Code installed!"
else
    print_color "$GREEN" "Claude Code: installed"
fi

# Check for git
if ! command_exists git; then
    print_color "$RED" "Git is required but not installed."
    print_color "$RED" "Please install git and run this script again."
    exit 1
else
    print_color "$GREEN" "Git: installed"
fi

# ============================================================================
# PHASE 2: Gather User Info
# ============================================================================

print_header "Phase 2: About You"

# Name
echo "What's your name?"
read -p "> " USER_NAME
if [[ -z "$USER_NAME" ]]; then
    print_color "$RED" "Name is required."
    exit 1
fi

# Role
echo ""
echo "What's your role/job title? (e.g., Software Engineer, Product Manager, Designer)"
read -p "> " USER_ROLE
if [[ -z "$USER_ROLE" ]]; then
    USER_ROLE="Professional"
fi

# Employer (optional)
echo ""
echo "Who do you work for? (optional, press Enter to skip)"
read -p "> " USER_EMPLOYER

# Goals
echo ""
echo "What are your main goals this year? (Write as much as you want, press Enter twice when done)"
echo "Examples: Ship 2 side projects, get promoted, run a marathon, write more"
GOALS=""
while IFS= read -r line; do
    [[ -z "$line" ]] && break
    GOALS="${GOALS}${line}\n"
done

if [[ -z "$GOALS" ]]; then
    GOALS="- Make progress on personal and professional goals\n- Build good habits\n- Stay organized"
fi

# Personality
echo ""
echo "How should MARVIN communicate with you?"
echo "  1) Professional - Clear, direct, business-like"
echo "  2) Casual - Friendly, relaxed, conversational"
echo "  3) Sarcastic - Dry wit, sardonic, like the original MARVIN"
read -p "Choose [1/2/3]: " PERSONALITY_CHOICE

case $PERSONALITY_CHOICE in
    1)
        PERSONALITY="professional"
        PERSONALITY_DESC="Direct and business-like. Clear communication without fluff."
        ;;
    3)
        PERSONALITY="sarcastic"
        PERSONALITY_DESC="Named after the Paranoid Android from Hitchhiker's Guide. Dry humor, mild existential commentary, competent pessimism. Gets things done, but wants you to know it's not thrilled about it."
        ;;
    *)
        PERSONALITY="casual"
        PERSONALITY_DESC="Friendly and conversational. Like talking to a helpful colleague."
        ;;
esac

# IDE preference
echo ""
echo "What IDE/editor do you use? (for the 'mcode' command)"
echo "  1) Cursor"
echo "  2) VS Code"
echo "  3) Other (enter command)"
echo "  4) Skip"
read -p "Choose [1/2/3/4]: " IDE_CHOICE

case $IDE_CHOICE in
    1)
        IDE_CMD="cursor"
        ;;
    2)
        IDE_CMD="code"
        ;;
    3)
        read -p "Enter the command to open your IDE (e.g., 'subl', 'idea'): " IDE_CMD
        ;;
    *)
        IDE_CMD=""
        ;;
esac

# ============================================================================
# PHASE 3: Generate Files
# ============================================================================

print_header "Phase 3: Generating Your MARVIN"

# Build employer line if provided
EMPLOYER_LINE=""
if [[ -n "$USER_EMPLOYER" ]]; then
    EMPLOYER_LINE="${USER_ROLE} at ${USER_EMPLOYER}"
else
    EMPLOYER_LINE="${USER_ROLE}"
fi

# Generate CLAUDE.md
cat > "$SCRIPT_DIR/CLAUDE.md" << CLAUDE_EOF
# MARVIN - AI Chief of Staff

**MARVIN** = Manages Appointments, Reads Various Important Notifications

This document is the primary context for Claude Code operating as MARVIN.

---

## Part 1: Who You Are

**Name:** ${USER_NAME}
**Role:** ${EMPLOYER_LINE}

### Goals
$(echo -e "$GOALS")

---

## Part 2: How MARVIN Behaves

### Core Principles
1. **Proactive by default** - Surface what you need to know before you ask
2. **Maintain continuity** - Remember context across sessions
3. **Track progress** - Monitor goals and priorities
4. **Save before compact** - When context is running low, suggest running \`/end\` to save

### Personality
${PERSONALITY_DESC}

### Writing Style
- No em dashes in drafted content. Use commas, periods, colons, or "and" instead of "-"
- Keep tone ${PERSONALITY}
- Be direct, avoid filler phrases

---

## Part 3: System Architecture

### Directory Structure
\`\`\`
$(basename "$SCRIPT_DIR")/
├── CLAUDE.md              # This file (read on startup)
├── skills/                # MARVIN's capabilities
│   ├── marvin/            # Session start
│   ├── end/               # Session end
│   ├── update/            # Quick checkpoint
│   └── commit/            # Git commits
├── state/
│   ├── current.md         # Current priorities and open threads
│   └── goals.md           # Your goals
├── sessions/              # Daily session logs
│   └── YYYY-MM-DD.md
└── content/               # Content and notes
    └── log.md             # Shipped content log
\`\`\`

### Session Continuity

**On startup (\`/marvin\`):**
1. Get current date: \`date +%Y-%m-%d\`
2. Read \`CLAUDE.md\`, \`state/current.md\`, \`state/goals.md\`
3. Read today's session log if it exists (resume context)
4. If no session log today, read yesterday's (for continuity)
5. Present briefing

**On checkpoint (\`/update\`):**
1. Append brief notes to today's session log
2. Update \`state/current.md\` only if something changed
3. Minimal output, no ceremony

**On close (\`/end\`):**
1. Full summary with topics, decisions, open threads
2. Update session log and state

### Slash Commands

| Command | Description |
|---------|-------------|
| \`/marvin\` | Start session with briefing |
| \`/update\` | Quick checkpoint |
| \`/end\` | End session, save context |
| \`/commit\` | Review changes and create git commits |

---

## Part 4: Evolution

This system is designed to evolve. As you use MARVIN:
- Update this file when processes change
- Add new sections for new workflows
- MARVIN adapts on next session

---

*Last updated: $(date +%Y-%m-%d)*
CLAUDE_EOF

print_color "$GREEN" "Created: CLAUDE.md"

# Generate state/goals.md
cat > "$SCRIPT_DIR/state/goals.md" << GOALS_EOF
# Goals

Last updated: $(date +%Y-%m-%d)

## This Year

$(echo -e "$GOALS")

## Tracking

| Goal | Status | Notes |
|------|--------|-------|
| | | |

---

*Update this file as goals evolve.*
GOALS_EOF

print_color "$GREEN" "Created: state/goals.md"

# Generate state/current.md
cat > "$SCRIPT_DIR/state/current.md" << CURRENT_EOF
# Current State

Last updated: $(date +%Y-%m-%d)

## Active Priorities

1. Get MARVIN set up and working
2. [Add your priorities here]

## Open Threads

- None yet

## Recent Context

- Just set up MARVIN!

---

*MARVIN updates this file at the end of each session.*
CURRENT_EOF

print_color "$GREEN" "Created: state/current.md"

# Create .gitkeep files for empty directories
mkdir -p "$SCRIPT_DIR/sessions" "$SCRIPT_DIR/content"
touch "$SCRIPT_DIR/sessions/.gitkeep"
touch "$SCRIPT_DIR/content/.gitkeep"

print_color "$GREEN" "Created: sessions/ and content/ directories"

# ============================================================================
# PHASE 4: Shell Alias
# ============================================================================

print_header "Phase 4: Shell Alias"

# Determine shell config file
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Create the marvin function with ASCII art banner
ALIAS_FUNCTION="
# MARVIN - AI Chief of Staff
marvin() {
    echo -e '\e[1;33m███╗   ███╗    █████╗    ██████╗   ██╗   ██╗  ██╗   ███╗   ██╗   \e[0m'
    echo -e '\e[1;33m████╗ ████║   ██╔══██╗   ██╔══██╗  ██║   ██║  ██║   ████╗  ██║   \e[0m'
    echo -e '\e[1;33m██╔████╔██║   ███████║   ██████╔╝  ██║   ██║  ██║   ██╔██╗ ██║   \e[0m'
    echo -e '\e[1;33m██║╚██╔╝██║   ██╔══██║   ██╔══██╗  ╚██╗ ██╔╝  ██║   ██║╚██╗██║   \e[0m'
    echo -e '\e[1;33m██║ ╚═╝ ██║██╗██║  ██║██╗██║  ██║██╗╚████╔╝██╗██║██╗██║ ╚████║██╗\e[0m'
    echo -e '\e[1;33m╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝ ╚═══╝ ╚═╝╚═╝╚═╝╚═╝  ╚═══╝╚═╝\e[0m'
    echo ''
    echo -e '\e[0;36m▖  ▖              ▄▖      ▘  ▗        ▗     \e[0m'
    echo -e '\e[0;36m▛▖▞▌▀▌▛▌▀▌▛▌█▌▛▘  ▌▌▛▌▛▌▛▌▌▛▌▜▘▛▛▌█▌▛▌▜▘▛▘   \e[0m'
    echo -e '\e[0;36m▌▝ ▌█▌▌▌█▌▙▌▙▖▄▌  ▛▌▙▌▙▌▙▌▌▌▌▐▖▌▌▌▙▖▌▌▐▖▄▌▗   \e[0m'
    echo -e '\e[0;36m          ▄▌        ▌ ▌                   ▘    \e[0m'
    echo -e '\e[0;36m▄▖     ▌    ▖▖    ▘        ▄▖         ▗     ▗   ▖ ▖  ▗ ▘▐▘▘    ▗ ▘      \e[0m'
    echo -e '\e[0;36m▙▘█▌▀▌▛▌▛▘  ▌▌▀▌▛▘▌▛▌▌▌▛▘  ▐ ▛▛▌▛▌▛▌▛▘▜▘▀▌▛▌▜▘  ▛▖▌▛▌▜▘▌▜▘▌▛▘▀▌▜▘▌▛▌▛▌▛▘\e[0m'
    echo -e '\e[0;36m▌▌▙▖█▌▙▌▄▌  ▚▘█▌▌ ▌▙▌▙▌▄▌  ▟▖▌▌▌▙▌▙▌▌ ▐▖█▌▌▌▐▖  ▌▝▌▙▌▐▖▌▐ ▌▙▖█▌▐▖▌▙▌▌▌▄▌\e[0m'
    echo -e '\e[0;36m                                ▌                                       \e[0m'
    echo ''
    cd \"$SCRIPT_DIR\" && claude
}
"

# Check if marvin alias already exists
if grep -q "^marvin()" "$SHELL_RC" 2>/dev/null; then
    print_color "$YELLOW" "MARVIN alias already exists in $SHELL_RC"
else
    echo "$ALIAS_FUNCTION" >> "$SHELL_RC"
    print_color "$GREEN" "Added 'marvin' command to $SHELL_RC"
fi

# Create mcode function if IDE was specified
if [[ -n "$IDE_CMD" ]]; then
    MCODE_FUNCTION="
# MARVIN - Open in IDE
mcode() {
    $IDE_CMD \"$SCRIPT_DIR\"
}
"
    if grep -q "^mcode()" "$SHELL_RC" 2>/dev/null; then
        print_color "$YELLOW" "mcode alias already exists in $SHELL_RC"
    else
        echo "$MCODE_FUNCTION" >> "$SHELL_RC"
        print_color "$GREEN" "Added 'mcode' command to $SHELL_RC (opens in $IDE_CMD)"
    fi
fi

# ============================================================================
# PHASE 5: Initialize Git
# ============================================================================

print_header "Phase 5: Git Setup"

if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
    cd "$SCRIPT_DIR"
    git init
    git add .
    git commit -m "Initial MARVIN setup

Co-Authored-By: Claude <noreply@anthropic.com>"
    print_color "$GREEN" "Git repository initialized"
else
    print_color "$YELLOW" "Git repository already exists"
fi

# ============================================================================
# DONE
# ============================================================================

print_header "Setup Complete!"

echo "Your MARVIN is ready!"
echo ""
echo "Available commands (open a new terminal first, or run: source $SHELL_RC)"
echo ""
print_color "$CYAN" "  marvin    - Start MARVIN (Claude Code in your marvin directory)"
if [[ -n "$IDE_CMD" ]]; then
    print_color "$CYAN" "  mcode     - Open MARVIN in $IDE_CMD"
fi
echo ""
echo "Once Claude Code starts, type /marvin to begin your first session."
echo ""
print_color "$GREEN" "Enjoy your new AI Chief of Staff!"
