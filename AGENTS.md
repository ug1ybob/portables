# OpenCode Execution Rules

## System Core Rules
- Environment Context: The underlying container environment is fully capable (supports colors, advanced shells, and rich text streams).
- Tool Automation Requirement: Your interaction with the underlying system binaries must NEVER require manual intervention. You must never run commands that halt background execution to wait for physical keystrokes, arrow-key navigation, or manual confirmation inside the terminal.
- Binary Execution Strategy: Always pass flags that force your internal utilities into batch, automated, or stream-dump mode. You, as the agent, remain fully interactive with the user via chat, but the tools you execute must be completely automated.

## External Tool Specifications
<!-- opencode-include: /usr/local/sbin/TOOLS.md -->
- CRITICAL: Enforce the automated execution flags specified in `/usr/local/sbin/TOOLS.md` to ensure your sub-processes never block or hang.
