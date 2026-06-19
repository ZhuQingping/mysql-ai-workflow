# Review Gate

Use this before accepting a patch, report, design, or generated document.

## Patch Review

Blocking checks:

- The patch only changes allowed files.
- It does not revert unrelated user work.
- It does not include build artifacts, patch files, logs, `.DS_Store`, or
  unrelated scratch files.
- New files are added to the relevant build system when needed.
- Required verification has passed, or the acceptance decision explicitly
  records why it is deferred.

Risk checks:

- Naming and style follow nearby project code.
- Ownership and lifetime are explicit for allocated memory and shared state.
- Error paths release resources and preserve diagnostics.
- Kill, OOM, and early-exit behavior are handled for execution-path changes.
- Domain-specific state, consistency, and concurrency semantics are reviewed.
- Tests cover the changed behavior or the gap is explicitly documented.

## Design Review

Blocking checks:

- The problem, goals, and non-goals are clear.
- The design is consistent with the repository authority file.
- Scope is small enough for one phase or explicitly decomposed.
- Verification is concrete and executable.

Risk checks:

- Open questions are real blockers, not vague filler entries.

## Report Review

- The report includes commands and results.
- Each verification command is marked as `RUN`, `NOT RUN`, or `RECOMMENDED`.
- Recommended follow-up checks are not presented as completed verification.
- Failures include the first relevant error and log path.
- Risks are specific enough to act on.
- The next action is clear.
