# Task Intake Template

Use this before dispatching an agent or starting implementation.

```text
Task title:
Scenario:
  feature-development | performance-optimization | bugfix-issue |
  test-migration | customer-docs | quality-hardening

Business or engineering goal:

Current evidence:
  - issue link / customer report / benchmark / failing test / design note

Repository context:
  - branch:
  - base commit:
  - worktree:
  - relevant docs:
  - relevant files:

Scope:
  In scope:
  Out of scope:

Allowed files:
  - maximum boundary only; does not grant edit permission

Forbidden files:

Expected deliverables:

Required verification:

Patch handoff:
  - patch path:
  - integration owner:

Risk level:
  low | medium | high | critical

Can run overnight:
  yes | no

Code-edit permission:
  DENIED by default unless the current human instruction or accepted task
  document explicitly authorizes edits. If the request says no edits,
  validation-only, review-only, or dry run, this must be DENIED even when
  allowed files are listed.

Human approval required before:
  design | code edit | test run | commit | external publish
```
