# Adapter Contract

Adapters translate the workflow into tool-specific execution. They do not define
workflow policy.

## Required Reads

Every adapter must load or point the agent to:

- repository entrypoint
- repository authority file
- `README.md`
- one scenario workflow
- `common/precedence.md`
- `common/agent-task-template.md`
- `common/agent-report-template.md`
- one domain profile, when the task needs it
- one feature task document, when the task belongs to an active feature

## Required Inputs

An adapter must capture:

- task title
- scenario
- role
- repository path
- base commit
- worktree path
- allowed files
- forbidden files
- verification command
- stop conditions
- code-edit permission
- artifact output path

## Edit Permission Rule

Adapters must treat code-edit permission as denied by default. `allowed files`
only define the edit boundary after permission is granted. A worktree path,
artifact path, obvious bug, passing reproduction, or low-risk patch is not
permission to edit.

If a request says `no edits`, `do not edit`, `validation-only`, `review-only`,
or `dry run`, the adapter must output `Code-edit permission: DENIED` and must
not generate a code-editing or patch-writing task.

## Required Outputs

An adapter must produce or require:

- changed files
- base commit
- patch path or explicit no-code-change statement
- commands run
- verification result
- risks
- scope deviations
- recommended next action

## Failure Behavior

The adapter must stop when:

- the repository authority file is missing
- allowed and forbidden files are absent for code-editing tasks
- code-edit permission is missing for tasks that request edits
- verification cannot run and no accepted waiver is provided
- the task conflicts with the repository authority file
