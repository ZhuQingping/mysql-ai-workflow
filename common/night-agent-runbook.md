# Night Agent Runbook

Night agents are useful for long-running research, test classification,
verification, review, and draft patch generation. They are not a replacement
for owner review.

## Allowed By Default

- Read repository docs and source.
- Compare reference implementations.
- Classify tests.
- Run approved build or test commands.
- Produce draft patches only when the task explicitly grants code-edit
  permission.
- Produce design, review, risk, and documentation reports.

## Not Allowed By Default

- Commit.
- Merge.
- Push.
- Rebase shared branches.
- Delete or rewrite user changes.
- Expand file scope without recording a stop condition.
- Make broad cross-layer execution changes without a phase task document.
- Edit any file unless the task explicitly grants code-edit permission, lists
  bounded files, and defines morning review.
- Publish externally or affect credentials, network state, production state, or
  billing without explicit approval.

## Required Input

Each night task should include:

- goal
- role
- scenario workflow
- allowed files
- forbidden files
- expected deliverable
- verification command
- stop conditions
- code-edit permission, if edits are expected

## Morning Review

The orchestrator reviews:

- report completeness
- patch scope
- verification output
- risks and blockers
- whether the result should be accepted, revised, or discarded
- whether any draft patch is safe to apply
