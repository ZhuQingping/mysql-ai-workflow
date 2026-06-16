# /workflow-dispatch

Create a bounded subagent or external-agent task prompt.

Read:

- `<workflow-repo>/adapters/contracts.md`
- `common/agent-task-template.md`
- `common/worktree-protocol.md`
- selected scenario workflow
- selected domain profile, when relevant

Require:

- role
- repository path
- base commit
- worktree path for parallel edits
- allowed files
- forbidden files
- verification command
- stop conditions
- code-edit permission if edits are expected

Return a self-contained task prompt. Do not dispatch broad tasks that mix
unrelated domains.

