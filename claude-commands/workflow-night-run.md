# /workflow-night-run

Prepare safe unattended AI work.

Read:

- `<workflow-repo>/common/night-agent-runbook.md`
- `common/worktree-protocol.md`
- `common/agent-task-template.md`
- selected scenario workflow
- selected domain profile, when relevant

Rules:

- default to read/report/test-classification
- require explicit code-edit permission for file edits
- require explicit approval for external publishing, credentials, network state,
  commits, pushes, merges, rebases, and destructive cleanup
- require artifact path and morning review checklist for draft patches

Return the night task prompt, allowed operations, forbidden operations,
verification command, stop conditions, and morning review checklist.

