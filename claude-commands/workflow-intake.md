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

Stop if the authority file, scope, or edit permission is unclear.

