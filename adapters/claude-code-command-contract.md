# Claude Code Command Contract

Claude Code commands, subagents, hooks, and memory should apply the workflow
without becoming the workflow source of truth.

## Slash Commands

Recommended commands:

- `/workflow-intake`: classify task and gather inputs.
- `/workflow-dispatch`: generate a bounded subagent prompt.
- `/workflow-review`: review a patch, report, or design.
- `/workflow-night-run`: prepare a night-safe task.

## Subagent Mapping

- Orchestrator: default interactive agent.
- Design Agent: research and design only unless edit permission is present.
- Code Agent: bounded implementation only.
- Test Agent: verification and failure reporting only.
- Review Agent: findings-first review.
- Docs Agent: external or internal documentation.

## Hook Mapping

Night-run hooks should block or require approval for:

- `git commit`
- `git push`
- `git merge`
- `git rebase`
- destructive file deletion
- commands that publish externally

## Memory Boundary

Claude memory may store personal preferences and cross-session lessons. It must
not replace:

- workflow policy in this repository
- project facts in the repository authority file
- task-specific decisions in feature task documents

## Validation Boundary

Non-interactive Claude Code command validation can take longer than simple CLI
smoke tests. Use a longer timeout window, capture stdout and stderr to files,
and record elapsed time before treating a run as failed.

Recommended validation sequence:

1. Run a plain control prompt and confirm the CLI returns output.
2. Run each slash-command prompt with a longer timeout.
3. Inspect the command output for workflow semantics, especially edit
   permission, stop conditions, and patch-writing instructions.
4. Confirm the target repository or worktree remains clean for read-only runs.
5. Fall back to interactive Claude Code validation only after the longer
   non-interactive run still hangs or returns no usable output.
