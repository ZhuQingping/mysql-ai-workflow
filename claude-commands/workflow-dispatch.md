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

Edit permission rule:

- code edits are denied by default
- allowed files are only the maximum boundary after permission is granted
- worktree paths, artifact paths, obvious fixes, or low-risk changes do not
  grant edit permission
- `no edits`, `do not edit`, `validation-only`, `review-only`, and `dry run`
  mean `Code-edit permission: DENIED`
- when permission is denied, produce a read-only validation/review task and do
  not include patch-writing instructions
- report `Code-edit permission: GRANTED` only when the current human
  instruction or accepted task document explicitly authorizes edits

Return a self-contained task prompt. Do not dispatch broad tasks that mix
unrelated domains.
