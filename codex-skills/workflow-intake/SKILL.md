---
name: workflow-intake
description: Use when starting an AI-assisted engineering task and you need to classify the scenario, gather required inputs, select workflow documents, and decide whether edits, tests, or night execution are allowed.
---

# Workflow Intake

Use this skill to turn an initial request into a bounded workflow task.

## Required Reads

Read from the workflow repository, defaulting to
`<workflow-repo>` unless the user names
another path:

- `README.md`
- `common/precedence.md`
- `common/task-intake-template.md`
- the selected scenario under `scenarios/`
- a domain profile under `profiles/`, when relevant

## Process

1. Identify the repository entrypoint and repository authority file for the
   target project.
2. Classify the scenario:
   - feature-development
   - performance-optimization
   - bugfix-issue
   - test-suite-migration
   - external-docs
   - quality-hardening
3. Fill the task intake fields in plain text.
4. Record whether code edits, tests, external publishing, or night execution are
   allowed.
5. Stop if the authority file or scope is unclear and a reasonable assumption
   would be risky.

## Output

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

