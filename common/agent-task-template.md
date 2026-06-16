# Agent Task Template

Use this for Codex, Claude Code, Cursor, or any other agent.

```text
Read first:
  - <repo-entrypoint>
  - <repo-authority-file>
  - <workflow-repo>/README.md
  - <scenario workflow>
  - <domain profile, if any>
  - <feature task document, if any>

Role:
  Orchestrator | Design Agent | Code Agent | Test Agent | Review Agent |
  Docs Agent

Task:

Goal:

Context:

Base commit:

Worktree:

Dirty-state policy:

Allowed files:

Forbidden files:

Reference files:

Required commands:

Patch output:

Expected output:
  - changed files
  - base commit
  - patch path or diff summary
  - summary
  - commands run
  - results
  - risks
  - next suggested task

Stop conditions:
  - scope expands beyond allowed files
  - design contradicts the repository authority file
  - verification cannot run and no fallback evidence exists
  - patch requires unrelated cleanup
  - dependency on another agent output is missing

Commit policy:
  Do not commit unless explicitly instructed.
```
