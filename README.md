# AI Workflows

This repository defines an agent-neutral workflow system for daily software
development. It is intentionally not tied to Codex, Claude Code, Cursor, or any
single automation platform or project.

Each project should define its own repository entrypoint and authority file.
This repository provides the reusable workflow layer: it describes how different
classes of work should move from intake to delivery.

## Design Principles

- Keep workflow assets agent-neutral. Tool-specific behavior belongs in
  `adapters/`.
- Use file-based handoff between agents: task documents, patches, reports,
  logs, and verification results.
- Keep implementation work bounded by explicit allowed and forbidden files.
- Let the orchestrator own cross-layer decisions, integration, review, and
  commits.
- Treat night work as draft-producing by default. Night agents may produce
  reports, patches, classifications, and test results, but should not merge
  changes without explicit approval.
- Prefer small, reviewable tasks over broad autonomous edits.

Adapters must follow `adapters/contracts.md`. Tool-specific files can add
mechanics, but cannot weaken common workflow rules.

## Directory Layout

```text
mysql_ai_workflow/
  README.md
  design.md

  common/
    precedence.md
    worktree-protocol.md
    task-intake-template.md
    design-template.md
    agent-task-template.md
    agent-report-template.md
    review-gate.md
    verification-matrix.md
    night-agent-runbook.md
    retrospective-template.md

  scenarios/
    feature-development.md
    performance-optimization.md
    bugfix-issue.md
    external-docs.md
    quality-hardening.md
    test-suite-migration.md

  adapters/
    contracts.md
    codex.md
    codex-skill-contract.md
    claude-code.md
    claude-code-command-contract.md
    cursor.md
    generic-agent.md

  profiles/
    mysql-kernel/
      README.md
      verification-matrix.md
      review-gate.md

  codex-skills/
    workflow-intake/
    workflow-dispatch/
    workflow-review/
    workflow-night-run/

  claude-commands/
    workflow-intake.md
    workflow-dispatch.md
    workflow-review.md
    workflow-night-run.md

  scripts/
    install_codex_skills.sh
    install_claude_commands.sh
```

## How To Choose A Workflow

- New feature: use `scenarios/feature-development.md`.
- Performance work: use `scenarios/performance-optimization.md`.
- Customer issue or bugfix: use `scenarios/bugfix-issue.md`.
- Test suite migration: use `scenarios/test-suite-migration.md`.
- External-facing docs or release notes: use `scenarios/external-docs.md`.
- Risk closure, stability, or regression hardening: use
  `scenarios/quality-hardening.md`.

For feature-specific work, also read that feature's task board and phase
documents. Feature-specific documents may add stricter rules, but should not
replace the common workflow layer.

For domain-specific work, also read the matching profile under `profiles/`.

## Examples

- `examples/task-prompts/bugfix-issue.md`
- `examples/reports/agent-report.md`

## Installation

Install Codex skills:

```bash
./scripts/install_codex_skills.sh
```

Install Claude Code slash commands:

```bash
./scripts/install_claude_commands.sh
```
