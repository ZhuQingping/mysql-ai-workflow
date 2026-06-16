# Codex Skill Contract

Codex skills should enforce workflow routing and stop conditions. They should
not duplicate scenario bodies or domain profile content.

## Skill Set

- `workflow-intake`: classify scenario and collect required inputs.
- `workflow-dispatch`: create a bounded agent task from the template.
- `workflow-review`: review a patch, report, or design against review gates.
- `workflow-night-run`: prepare a night-safe task with explicit permissions.

## Required Behavior

Each skill must:

- read `adapters/contracts.md`
- read the selected scenario workflow
- read `common/precedence.md`
- read `common/agent-task-template.md` or `common/agent-report-template.md`
- stop if required inputs are missing
- produce a file-based task or report artifact

## Code-Edit Rule

No Codex skill may edit files unless the task explicitly grants code-edit
permission and lists allowed and forbidden files.

## Verification Rule

If verification cannot run, the skill must record:

- command that should have run
- reason it did not run
- risk of accepting without it
- owner decision required before acceptance

