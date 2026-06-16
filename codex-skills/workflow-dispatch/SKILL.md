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

## Edit Permission Rule

Code edits are denied by default. Allowed files define the maximum boundary only
after edit permission is granted; they do not grant permission by themselves.
Worktree paths, artifact paths, obvious fixes, or low-risk changes do not grant
edit permission.

If the request says `no edits`, `do not edit`, `validation-only`,
`review-only`, or `dry run`, output `Code-edit permission: DENIED`, produce a
read-only validation/review task, and do not include patch-writing instructions.

Report `Code-edit permission: GRANTED` only when the current human instruction
or accepted task document explicitly authorizes edits, and only for the named
allowed files.

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
