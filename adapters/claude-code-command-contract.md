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

