# Adapter: Claude Code

Use Claude Code as an interactive agent, subagent host, or delegated worker
while keeping workflow content in `Docs/ai_workflows/`.

## Context Entry

Claude Code should read:

- the repository entrypoint
- `CLAUDE.md` when the project uses it as the authority file
- this workflow repository's `README.md`
- the relevant scenario workflow
- the relevant domain profile, if any
- the relevant feature task document

## Recommended Usage

- Use `CLAUDE.md` for repository memory and stable project constraints.
- Use subagents for Design, Test, Review, and bounded Code roles.
- Use `.claude/commands/` for repeatable slash-command entry points that load a
  scenario workflow and generate a task prompt.
- Use hooks for lightweight pre-command or post-command checks when they reduce
  repeated mistakes.
- Use MCP for systems that provide real project context, such as issue trackers,
  code hosting, documentation, or benchmark artifacts.
- Follow `common/worktree-protocol.md` when using subagents for code-editing
  tasks.

## Suggested Mapping

- Scenario workflow: slash command or orchestrator prompt.
- Agent role: Claude Code subagent description.
- Allowed and forbidden files: explicit prompt constraints plus review gate.
- Night restrictions: hooks or permission settings for commands such as
  `git commit`, `git push`, `git merge`, and destructive file operations.
- External context: MCP servers only when they provide authoritative project
  data.
- Memory: store personal preferences and cross-session lessons, not workflow
  rules that belong in this repository or project facts that belong in the
  repository authority file.

## Claude-Specific Assets

Claude commands, subagents, and hooks should act as adapters over these workflow
docs. They should not become the source of truth for process rules.

## Command Contract

Claude Code commands, subagents, hooks, and memory should follow
`adapters/claude-code-command-contract.md`.
