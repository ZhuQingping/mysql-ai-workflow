---
name: workflow-night-run
description: Use when preparing overnight or unattended AI agent work with strict safety boundaries, explicit edit permissions, artifact handoff, verification commands, and morning review requirements.
---

# Workflow Night Run

Use this skill to prepare safe unattended work.

## Required Reads

Read from the workflow repository, defaulting to
`<workflow-repo>` unless the user names
another path:

- `common/night-agent-runbook.md`
- `common/worktree-protocol.md`
- `common/agent-task-template.md`
- selected scenario workflow
- selected domain profile, when relevant

## Safety Rule

Night work is read/report/test-classification by default. File edits require
explicit code-edit permission, bounded files, verification command, artifact
path, and morning review.

## Process

1. Classify the task and select the scenario.
2. Confirm allowed operations:
   - read
   - run tests
   - edit files
   - produce patch
   - publish externally
3. Require explicit approval for edits, external publishing, credentials,
   network-affecting operations, commits, pushes, merges, rebases, and
   destructive cleanup.
4. Define morning review criteria.

## Output

Return:

- night task prompt
- allowed operations
- forbidden operations
- worktree path
- artifact path
- verification command
- stop conditions
- morning review checklist
