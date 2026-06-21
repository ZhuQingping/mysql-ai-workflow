# AI Workflows

Languages: English | [简体中文](README.zh-CN.md)

This repository defines an agent-neutral workflow system for daily software
development. It is intentionally not tied to Codex, Claude Code, Cursor, or any
single automation platform or project.

Each project should define its own repository entrypoint and authority file.
This repository provides the reusable workflow layer: it describes how different
classes of work should move from intake to delivery.

The English README is the primary maintenance source. Translations should keep
the same workflow semantics, command names, file paths, and safety rules.

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
      acceptance-standard.md

  codex-skills/
    workflow-intake/
    workflow-dispatch/
    workflow-review/
    workflow-night-run/
    mysql-acceptance-gate/

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

## Typical Usage Patterns

Use this repository as the reusable workflow layer. Work starts in the target
code repository, while this repository supplies the task classification,
handoff templates, review gates, and tool adapters.

Every task should start with intake:

```text
Use the workflow repository:
<path-to>/mysql_ai_workflow

Run workflow-intake first. Do not edit files yet.

Target repository:
<current project path>

Task:
<describe the issue, feature, test work, documentation work, or quality work>

Return:
- scenario
- required reads
- scope
- allowed files
- forbidden files
- verification command
- code-edit permission
- night-run permission
- next workflow step
```

### Issue Fix

Use for customer issues, internal bug reports, failing tests, wrong results,
crashes, regressions, or production incidents.

Workflow:

```text
workflow-intake
-> reproduce and collect evidence
-> workflow-dispatch Code Agent
-> workflow-review
-> human integration or commit
```

Example prompt:

```text
Use workflow-intake and workflow-dispatch.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Scenario:
bugfix-issue

Problem:
<failing command, error message, customer symptom, or wrong result>

Current phase:
intake only. No edits.

After intake is accepted, create a bounded Code Agent task with:
- explicit allowed files
- explicit forbidden files
- verification command
- patch output path
- no commit
```

### New Feature Development

Use for new behavior, new syntax, new APIs, optimizer or execution changes,
storage behavior, compatibility work, or larger multi-phase implementation.

Workflow:

```text
workflow-intake
-> design task
-> design review
-> split into bounded implementation tasks
-> parallel or serial workflow-dispatch
-> workflow-review for each patch
-> integration verification
-> docs and retrospective
```

Example prompt:

```text
Use workflow-intake for a new feature.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Feature:
<describe the requirement and expected behavior>

Current phase:
design only. No code edits.

Output:
- scenario: feature-development
- design questions
- affected modules
- required tests
- risk areas
- proposed task split
- whether parallel agents are safe
```

### Self-Test And Verification

Use for self-testing before handoff, regression validation, reproducing a
failure, checking a patch, or building confidence before review.

Workflow:

```text
workflow-intake
-> identify authoritative test commands
-> run scoped verification
-> workflow-review if a patch or report exists
-> record gaps and owner decisions
```

Example prompt:

```text
Use workflow-intake for self-test.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Validate the current working tree before review.

No code edits.

Please:
- read the repository authority file
- identify required verification commands
- run only the agreed scoped tests
- report pass/fail output
- list verification gaps
- do not commit
```

### Performance Optimization

Use for latency, throughput, CPU, memory, lock contention, plan quality, IO, or
benchmark regressions.

Workflow:

```text
workflow-intake
-> baseline benchmark
-> hypothesis and profiling tasks
-> bounded optimization patch
-> before/after benchmark comparison
-> workflow-review
```

Example prompt:

```text
Use workflow-intake for performance-optimization.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Problem:
<benchmark, query, workload, flamegraph, or regression evidence>

Current phase:
analysis only. No edits.

Output baseline commands, suspected components, profiling plan, risk areas,
and the smallest safe next task.
```

### Test Migration

Use for moving tests between frameworks, stabilizing flaky tests, splitting
large test suites, or adding coverage for migrated behavior.

Workflow:

```text
workflow-intake
-> test-suite-migration plan
-> migrate a bounded batch
-> run old and new verification where practical
-> workflow-review
```

Example prompt:

```text
Use workflow-intake for test-suite-migration.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Migrate <test group> from <old framework> to <new framework>.

Current phase:
planning only. No edits.

Return migration scope, files, equivalence checks, forbidden areas, and
verification commands.
```

### Documentation

Use for customer-facing docs, release notes, design notes, runbooks, upgrade
notes, or internal engineering handoff.

Workflow:

```text
workflow-intake
-> external-docs or feature-development docs task
-> Docs Agent draft
-> workflow-review
-> human publish approval
```

Example prompt:

```text
Use workflow-intake for external-docs.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Draft customer-facing documentation for <feature or fix>.

No external publishing.

Return source facts to read, audience, required examples, forbidden claims,
reviewers, and publish gate.
```

### Quality Hardening

Use for risk closure, boundary tests, regression hardening, static analysis,
fuzzing, cleanup after a feature, or release-readiness work.

Workflow:

```text
workflow-intake
-> quality-hardening plan
-> dispatch focused agents for risk areas
-> workflow-review
-> verification matrix update
```

Example prompt:

```text
Use workflow-intake for quality-hardening.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Harden <component or feature> before handoff.

Current phase:
analysis and test planning only. No edits.

Return risk list, missing tests, verification matrix, candidate bounded tasks,
and stop conditions.
```

## Examples

- `examples/task-prompts/bugfix-issue.md`
- `examples/reports/agent-report.md`

## Installation

### Local Machine

Install Codex skills:

```bash
./scripts/install_codex_skills.sh
```

Install Claude Code slash commands:

```bash
./scripts/install_claude_commands.sh
```

### Another Machine

Clone or copy this repository to the new machine, then run the install scripts
from the repository root:

```bash
git clone <repo-url> mysql_ai_workflow
cd mysql_ai_workflow
./scripts/install_codex_skills.sh
./scripts/install_claude_commands.sh
```

If the repository is copied without Git, the same install scripts still work as
long as the directory layout is preserved.

After installation:

- Codex skills are installed under `~/.codex/skills/`.
- Claude Code slash commands are installed under `~/.claude/commands/`.
- Target code repositories do not need to vendor this workflow repository.

For each target repository, add only a small agent entrypoint such as
`AGENTS.md` or `CLAUDE.md` that points to the project authority file and this
workflow repository:

```md
# AI Agent Entry

Repository authority file: CLAUDE.md

Reusable workflow repository:
<path-to>/mysql_ai_workflow

All AI tasks must start with workflow-intake and must report:
- scenario
- scope
- allowed files
- forbidden files
- verification command
- code-edit permission
- commit policy

Code edits are denied unless the current human instruction explicitly grants
permission.
```

On machines where the workflow repository path differs, either:

- mention the absolute path in each prompt, or
- update the target repository entrypoint to point to the local path, or
- keep a stable symlink such as `~/Workflows/mysql_ai_workflow`.
