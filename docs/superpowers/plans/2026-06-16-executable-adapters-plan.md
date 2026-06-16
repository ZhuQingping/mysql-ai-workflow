# Executable Adapters Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the reusable workflow documents into concrete adapter artifacts for Codex and Claude Code without making either tool the source of truth.

**Architecture:** The workflow repository remains the source of process truth. Adapter artifacts reference `README.md`, `common/`, `scenarios/`, and `profiles/`, then enforce required reads, stop conditions, and report formats for each tool. A smoke-test task validates that both adapters produce comparable task prompts and reports.

**Tech Stack:** Markdown, shell, Codex skills, Claude Code slash commands/hooks, file-based reports.

---

## File Structure

- Create `adapters/contracts.md`: common adapter contract shared by all tools.
- Create `adapters/codex-skill-contract.md`: Codex skill behavior and trigger rules.
- Create `adapters/claude-code-command-contract.md`: Claude Code slash command, subagent, hook, and memory mapping.
- Create `examples/task-prompts/bugfix-issue.md`: sample task prompt generated from the common template.
- Create `examples/reports/agent-report.md`: sample completed agent report.
- Modify `README.md`: link the adapter contracts and examples.
- Modify `adapters/codex.md`: point to the Codex skill contract.
- Modify `adapters/claude-code.md`: point to the Claude Code command contract.

### Task 1: Common Adapter Contract

**Files:**
- Create: `adapters/contracts.md`
- Modify: `README.md`

- [ ] **Step 1: Create the shared adapter contract**

Create `adapters/contracts.md` with:

```markdown
# Adapter Contract

Adapters translate the workflow into tool-specific execution. They do not define
workflow policy.

## Required Reads

Every adapter must load or point the agent to:

- repository entrypoint
- repository authority file
- `README.md`
- one scenario workflow
- `common/precedence.md`
- `common/agent-task-template.md`
- `common/agent-report-template.md`
- one domain profile, when the task needs it
- one feature task document, when the task belongs to an active feature

## Required Inputs

An adapter must capture:

- task title
- scenario
- role
- repository path
- base commit
- worktree path
- allowed files
- forbidden files
- verification command
- stop conditions
- code-edit permission
- artifact output path

## Required Outputs

An adapter must produce or require:

- changed files
- base commit
- patch path or explicit no-code-change statement
- commands run
- verification result
- risks
- scope deviations
- recommended next action

## Failure Behavior

The adapter must stop when:

- the repository authority file is missing
- allowed and forbidden files are absent for code-editing tasks
- code-edit permission is missing for tasks that request edits
- verification cannot run and no accepted waiver is provided
- the task conflicts with the repository authority file
```

- [ ] **Step 2: Link the contract from README**

Modify `README.md` under `Directory Layout` to include:

```text
  adapters/
    contracts.md
    codex.md
    codex-skill-contract.md
    claude-code.md
    claude-code-command-contract.md
    cursor.md
    generic-agent.md
```

Add this paragraph after `Design Principles`:

```markdown
Adapters must follow `adapters/contracts.md`. Tool-specific files can add
mechanics, but cannot weaken common workflow rules.
```

- [ ] **Step 3: Verify links**

Run:

```bash
test -f adapters/contracts.md
rg -n "adapters/contracts.md|contracts.md" README.md
```

Expected: both commands succeed and show the README references.

### Task 2: Codex Skill Contract

**Files:**
- Create: `adapters/codex-skill-contract.md`
- Modify: `adapters/codex.md`

- [ ] **Step 1: Create Codex skill contract**

Create `adapters/codex-skill-contract.md` with:

```markdown
# Codex Skill Contract

Codex skills should enforce workflow routing and stop conditions. They should
not duplicate scenario bodies or domain profile content.

## Skill Set

- `workflow-intake`: classify scenario and collect required inputs.
- `workflow-dispatch`: create a bounded agent task from the template.
- `workflow-review`: review a patch, report, or design against review gates.
- `workflow-night-run`: prepare a night-safe task with explicit permissions.

## Required Behavior

Each skill must:

- read `adapters/contracts.md`
- read the selected scenario workflow
- read `common/precedence.md`
- read `common/agent-task-template.md` or `common/agent-report-template.md`
- stop if required inputs are missing
- produce a file-based task or report artifact

## Code-Edit Rule

No Codex skill may edit files unless the task explicitly grants code-edit
permission and lists allowed and forbidden files.

## Verification Rule

If verification cannot run, the skill must record:

- command that should have run
- reason it did not run
- risk of accepting without it
- owner decision required before acceptance
```

- [ ] **Step 2: Link from Codex adapter**

Append to `adapters/codex.md`:

```markdown
## Skill Contract

When Codex skills are created, they should follow
`adapters/codex-skill-contract.md`.
```

- [ ] **Step 3: Verify Codex references**

Run:

```bash
test -f adapters/codex-skill-contract.md
rg -n "codex-skill-contract|workflow-intake|workflow-night-run" adapters/codex*.md
```

Expected: the contract file exists and references are found.

### Task 3: Claude Code Command Contract

**Files:**
- Create: `adapters/claude-code-command-contract.md`
- Modify: `adapters/claude-code.md`

- [ ] **Step 1: Create Claude Code command contract**

Create `adapters/claude-code-command-contract.md` with:

```markdown
# Claude Code Command Contract

Claude Code commands, subagents, hooks, and memory should apply the workflow
without becoming the workflow source of truth.

## Slash Commands

Recommended commands:

- `/workflow-intake`: classify task and gather inputs.
- `/workflow-dispatch`: generate a bounded subagent prompt.
- `/workflow-review`: review a patch, report, or design.
- `/workflow-night-run`: prepare a night-safe task.

## Subagent Mapping

- Orchestrator: default interactive agent.
- Design Agent: research and design only unless edit permission is present.
- Code Agent: bounded implementation only.
- Test Agent: verification and failure reporting only.
- Review Agent: findings-first review.
- Docs Agent: external or internal documentation.

## Hook Mapping

Night-run hooks should block or require approval for:

- `git commit`
- `git push`
- `git merge`
- `git rebase`
- destructive file deletion
- commands that publish externally

## Memory Boundary

Claude memory may store personal preferences and cross-session lessons. It must
not replace:

- workflow policy in this repository
- project facts in the repository authority file
- task-specific decisions in feature task documents
```

- [ ] **Step 2: Link from Claude Code adapter**

Append to `adapters/claude-code.md`:

```markdown
## Command Contract

Claude Code commands, subagents, hooks, and memory should follow
`adapters/claude-code-command-contract.md`.
```

- [ ] **Step 3: Verify Claude references**

Run:

```bash
test -f adapters/claude-code-command-contract.md
rg -n "claude-code-command-contract|/workflow-intake|Memory Boundary" adapters/claude-code*.md
```

Expected: the contract file exists and references are found.

### Task 4: Example Task And Report Artifacts

**Files:**
- Create: `examples/task-prompts/bugfix-issue.md`
- Create: `examples/reports/agent-report.md`
- Modify: `README.md`

- [ ] **Step 1: Create example directories**

Run:

```bash
mkdir -p examples/task-prompts examples/reports
```

Expected: both directories exist.

- [ ] **Step 2: Create sample bugfix task prompt**

Create `examples/task-prompts/bugfix-issue.md` with:

```markdown
# Example Agent Task: Bugfix Issue

Read first:

- `<repo-entrypoint>`
- `<repo-authority-file>`
- `README.md`
- `scenarios/bugfix-issue.md`
- `common/precedence.md`
- `common/agent-task-template.md`
- `common/agent-report-template.md`

Role: Code Agent

Task: Fix a reproducible wrong-result issue in a bounded module.

Goal: Identify root cause, implement the smallest safe fix, and add regression
coverage.

Base commit: `<base-commit>`

Worktree: `<worktree-path>`

Allowed files:

- `<module-path>`
- `<test-path>`

Forbidden files:

- `<unrelated-path>`
- build output directories

Required commands:

- `<project-build-command>`
- `<targeted-test-command>`

Stop conditions:

- reproduction cannot be established
- root cause is outside allowed files
- test infrastructure is broken independently
- verification cannot run

Commit policy: Do not commit.
```

- [ ] **Step 3: Create sample agent report**

Create `examples/reports/agent-report.md` with:

```markdown
# Example Agent Report

Task: Fix reproducible wrong-result issue
Role: Code Agent
Agent type: Codex
Model version: `<model>`
Session/run ID: `<session-id>`
Status: DRAFT

Changed files:

- `<module-path>`
- `<test-path>`

Base commit: `<base-commit>`

Diff source:

- worktree: `<worktree-path>`
- patch path: `.ai-artifacts/<task-id>/<agent-id>-<base-commit>.patch`

Excluded artifacts:

- build outputs: none
- logs: `<log-path>`
- scratch files: none

Summary:

The root cause was isolated to `<function-or-module>`. The patch adds a minimal
guard and a regression test.

Commands run:

- `<project-build-command>`: PASS
- `<targeted-test-command>`: PASS

Risks:

- Broader suite not run.

Recommended next action:

Run related suite and review patch ownership.

Human review required: yes
```

- [ ] **Step 4: Link examples from README**

Add to `README.md`:

```markdown
## Examples

- `examples/task-prompts/bugfix-issue.md`
- `examples/reports/agent-report.md`
```

- [ ] **Step 5: Verify examples**

Run:

```bash
test -f examples/task-prompts/bugfix-issue.md
test -f examples/reports/agent-report.md
rg -n "examples/task-prompts|examples/reports" README.md
```

Expected: all commands succeed.

### Task 5: Final Documentation Review

**Files:**
- Review only: all Markdown files

- [ ] **Step 1: Scan for project-specific coupling in core**

Run:

```bash
rg -n "P[Q]|parallel_quer[y]|Parallel Quer[y]|MySQ[L]|InnoD[B]|MT[R]|build-ninj[a]|mysql-tes[t]" README.md design.md common scenarios adapters
```

Expected: no matches outside intentional adapter examples such as `AGENTS.md` or `CLAUDE.md`.

- [ ] **Step 2: Scan for unfinished markers**

Run:

```bash
rg -n "$(printf 'TB%s|TO%sO|FIXM%s|待%s|占%s' D D E 定 位)" .
```

Expected: no matches.

- [ ] **Step 3: Review git status**

Run:

```bash
git status --short
```

Expected: only workflow repository files are listed.

- [ ] **Step 4: Commit when approved**

Only after owner approval, run:

```bash
git add .
git commit -m "Add reusable AI workflow system"
```

Expected: commit contains only workflow repository files.
