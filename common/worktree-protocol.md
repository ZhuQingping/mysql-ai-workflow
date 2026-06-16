# Worktree Protocol

Use this when dispatching independent agents that may produce patches.

## Before Dispatch

- Record the base commit: `git rev-parse HEAD`.
- Record the main worktree state: `git status --short`.
- Do not dispatch code-editing agents from a dirty main worktree unless the task
  explicitly states how existing changes are handled.
- Create one worktree per independent task.
- Use a task-specific branch name, for example
  `<agent>/<scenario>-<short-task>`.
- Define allowed files, forbidden files, verification commands, and stop
  conditions before the agent starts.

## Worktree Rules

- A delegated agent works only inside its assigned worktree.
- A delegated agent does not commit unless explicitly instructed.
- A delegated agent writes a report using `agent-report-template.md`.
- A delegated agent exports a patch from its worktree into a dedicated artifact
  directory:

```bash
mkdir -p /path/to/main-repo/.ai-artifacts/<task-id>
git diff > /path/to/main-repo/.ai-artifacts/<task-id>/<agent-id>-<base-commit>.patch
```

- Build directories are worktree-local unless the task states otherwise.
- Long-running tests must use distinct temporary directories when concurrent
  runs could collide.

## Integration

The orchestrator reviews patches in the main repository:

```bash
git apply --check <task-name>.patch
git apply --stat <task-name>.patch
```

Before applying a patch, check:

- the patch base commit matches the intended base or has been rebased manually
- the patch filename or report records task id, agent id, and base commit
- changed files match the allowed file list
- generated files, logs, build artifacts, and scratch files are excluded
- no unrelated user changes are reverted
- validation evidence is present or the gap is explicitly accepted

## Cleanup

After acceptance or rejection:

- archive the report or decision in the relevant task document
- remove temporary patch files when no longer needed
- remove worktrees only after confirming no useful uncommitted work remains
