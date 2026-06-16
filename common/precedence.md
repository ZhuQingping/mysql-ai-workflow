# Workflow Precedence

Use this order when two instructions conflict:

1. Human instruction in the current conversation.
2. Repository authority file, as routed by the repository entrypoint.
3. Feature-specific task boards, phase documents, and accepted design docs.
4. Domain profiles that add stricter checks for the current task.
5. Common workflow rules and scenario workflows.
6. Tool adapters under `adapters/`.
7. Agent-local memory, generated prompts, scratch notes, and draft reports.

Feature-specific documents and domain profiles may narrow scope, add tests, or
impose stricter ownership rules. Narrower or stricter safety rules win over
broader defaults.

## Edit Permission Gate

Code edits are denied by default.

Allowed files define the maximum edit boundary only after edit permission is
granted. They do not grant edit permission by themselves. Worktree paths,
artifact paths, reproducible failures, obvious fixes, or low-risk changes also
do not grant edit permission.

Treat the task as read-only when the request says `no edits`, `do not edit`,
`validation-only`, `review-only`, `dry run`, or when code-edit permission is not
explicit. In those cases, report `Code-edit permission: DENIED` and do not
produce a patch-writing task.

Report `Code-edit permission: GRANTED` only when the current human instruction
or accepted task document explicitly authorizes edits, and only for the named
allowed files.

Adapters describe how a tool executes the workflow. They are not the workflow
source of truth.
