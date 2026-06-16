---
name: workflow-review
description: Use when reviewing an AI-produced design, patch, task report, or workflow artifact against common review gates, domain profiles, verification evidence, and scope boundaries.
---

# Workflow Review

Use this skill before accepting a design, patch, report, or generated workflow
artifact.

## Required Reads

Read from the workflow repository, defaulting to
`<workflow-repo>` unless the user names
another path:

- `common/precedence.md`
- `common/review-gate.md`
- `common/verification-matrix.md`
- `common/agent-report-template.md`
- selected scenario workflow
- selected domain profile review gate, when relevant

## Process

1. Review findings first, ordered by severity.
2. Check scope against allowed and forbidden files.
3. Check that verification evidence is present or explicitly waived.
4. Check that generated artifacts, logs, build outputs, and scratch files are
   excluded.
5. Treat missing base commit, patch path, or command output as review risks.

## Output

Use this structure:

```text
Findings:
  Critical:
  Important:
  Minor:

Open questions:

Verification:

Recommendation:
  ACCEPT | ACCEPT WITH RISKS | REVISE | REJECT
```
