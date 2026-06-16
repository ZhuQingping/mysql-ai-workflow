# /workflow-intake

Classify an engineering task and gather required workflow inputs.

Read:

- repository entrypoint
- repository authority file
- `<workflow-repo>/README.md`
- `common/precedence.md`
- `common/task-intake-template.md`
- selected scenario workflow
- selected domain profile, when relevant

Return:

- scenario
- required reads
- scope
- allowed files
- forbidden files
- verification command
- edit permission
- night-run permission
- next workflow step

Edit permission rule:

- code edits are denied by default
- allowed files are only the maximum boundary after permission is granted
- `no edits`, `do not edit`, `validation-only`, `review-only`, and `dry run`
  mean `Code-edit permission: DENIED`
- report `Code-edit permission: GRANTED` only when the current human
  instruction or accepted task document explicitly authorizes edits

Stop if the authority file, scope, or edit permission is unclear.
