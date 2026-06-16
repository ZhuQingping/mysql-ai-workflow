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

