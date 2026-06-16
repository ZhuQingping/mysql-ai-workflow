---
name: workflow-dispatch
description: Use when dispatching a bounded AI agent task, creating a task prompt, assigning a role, defining allowed and forbidden files, setting stop conditions, and preparing worktree or patch handoff.
---

# Workflow Dispatch

Use this skill to create a task prompt for Codex, Claude Code, Cursor, or a
generic agent.

## Required Reads

Read from the workflow repository, defaulting to
`<workflow-repo>` unless the user names
another path:

- `adapters/contracts.md`
- `common/precedence.md`
- `common/agent-task-template.md`
- `common/worktree-protocol.md`
- selected scenario workflow
- selected domain profile, when relevant

## Process

1. Confirm the task has a scenario, role, repository path, base commit, allowed
   files, forbidden files, verification command, and stop conditions.
2. If code edits are expected, require explicit code-edit permission.
3. If parallel work is expected, require a worktree path and artifact path.
4. Produce a self-contained task prompt.
5. Do not dispatch broad tasks that mix unrelated domains.

## Output

Return a task prompt containing:

- required reads
- role
- task
- goal
- base commit
- worktree
- dirty-state policy
- allowed files
- forbidden files
- required commands
- patch output
- expected report format
- stop conditions
- commit policy
