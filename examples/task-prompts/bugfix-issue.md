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

